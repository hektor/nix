{
  lib,
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
let
  username = "h";
  hostName = "andromache";
  wolInterfaces = import ./wol-interfaces.nix;
in
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../modules/common
    ./hard.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.sops-nix.nixosModules.sops
    ../../modules/boot/bootloader.nix
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib config;
      device = "/dev/nvme1n1";
    })
    ../../modules/desktops/niri
    ../../modules/bluetooth
    ../../modules/keyboard
    (import ../../modules/networking { inherit hostName; })
    ../../modules/users
    ../../modules/audio
    ../../modules/localization
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
    (import ../../modules/secrets { inherit lib inputs config; })
    ../../modules/docker
  ];

  home-manager.users.${username} = import ../../home/hosts/andromache {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };

  networking.hostName = hostName;

  ssh.username = username;
  ssh.authorizedHosts = [ "astyanax" ];

  secrets.username = username;
  docker.user = username;

  nix.settings.secret-key-files = [ config.sops.secrets.nix_signing_key_andromache.path ];

  disko.devices = {
    disk.data = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          data = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/data";
            };
          };
        };
      };
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = [
    inputs.colmena.packages.${pkgs.system}.colmena
  ];


  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
    };

    openssh = {
      enable = true;
      harden = true;
    };

    syncthing = {
      enable = true;
      openDefaultPorts = true;
      settings = {
        devices = {
          # "device1" = {
          #   id = "DEVICE-ID-GOES-HERE";
          # };
        };
        folders = {
          "/home/${username}/sync" = {
            id = "sync";
            devices = [ ];
          };
        };
      };
    };
    locate = {
      enable = true;
      package = pkgs.plocate;
    };
  };

  networking = {
    # TODO: generate unique hostId on actual host with: head -c 8 /etc/machine-id
    hostId = "80eef97e";
    interfaces = {
      eno1 = {
        wakeOnLan.enable = true;
        inherit (wolInterfaces.eno1) macAddress;
      };
    };
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };
}
