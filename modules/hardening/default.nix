{
  inputs,
  config,
  lib,
  ...
}:

let
  unusedProtocols = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
  ];
  wakeOnLan = lib.any (iface: iface.wakeOnLan.enable) (lib.attrValues config.networking.interfaces);
  randomMac = config.host.role == "laptop" && !wakeOnLan;
  desktop = {
    preset = [
      "compatibility"
    ]
    ++ lib.optional config.gaming.enable "performance"; # prioritized (order matters) <https://github.com/cynicsketch/nix-mineral#configuring-options>
    settings = {
      debug.debugfs = true;
      etc.harden-bluetooth = false;
    };
  };
  profiles = {
    inherit desktop;

    laptop = lib.recursiveUpdate desktop {
      preset = [
        "compatibility"
        "performance"
      ];
      settings.kernel.iommu-passthrough = false;
    };

    server = {
      preset = [
        "compatibility"
        "maximum" # prioritized (order matters) <https://github.com/cynicsketch/nix-mineral#configuring-options>
      ];
      settings = {
        debug.quiet-boot = false;
        network = {
          ipv6-tempaddr = false;
          max-addresses = false;
          neighbor-solicitations = false;
          router-solicitations = false;
        };
        system = {
          lower-address-mmap = false;
          multilib = false;
          yama = "admin-only";
        };
      };
      extras = {
        kernel.warn-panic = false;
        system.secure-chrony = null;
        network = {
          tcp-window-scaling = true;
        };
      };
    };
  };
in
{
  imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];

  options.hardening = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
    profile = lib.mkOption {
      default = if profiles ? ${config.host.role} then config.host.role else null;
      type = lib.types.nullOr (lib.types.enum (lib.attrNames profiles));
    };
  };

  config = lib.mkIf config.hardening.enable {
    assertions = [
      {
        assertion = config.hardening.profile != null;
        message = "no 'hardening.profile' for `${config.host.role}` host role";
      }
    ];
    boot.blacklistedKernelModules = unusedProtocols;
    boot.extraModprobeConfig = lib.concatMapStrings (m: "install ${m} /bin/false\n") unusedProtocols;
    hardware.bluetooth.settings.General = lib.mkIf config.hardware.bluetooth.enable {
      PairableTimeout = 30;
      DiscoverableTimeout = 30;
      TemporaryTimeout = 0;
    };
    networking.wireless.iwd.settings.General.AddressRandomization = lib.mkIf randomMac "network";
    nix-mineral = lib.mkMerge [
      {
        enable = true;
        filesystems.normal = {
          "/tmp".enable = !config.boot.tmp.useTmpfs;
          # only needed for FAT
          "/boot".options.umask = lib.mkIf (
            !lib.elem (config.fileSystems."/boot".fsType or null) [
              "vfat"
              "msdos"
              "exfat"
            ]
          ) (lib.mkForce false);
        };
        settings = {
          etc.harden-gitconfig = false;
          kernel.cpu-mitigations = "smt-on";
          network = {
            ip-forwarding = config.virtualisation.docker.enable || config.services.k3s.enable;
            random-mac = randomMac;
            router-advertisements = "on";
            tcp-sack = true;
          };
        };
      }
      (lib.optionalAttrs (config.hardening.profile != null) profiles.${config.hardening.profile})
    ];
  };
}
