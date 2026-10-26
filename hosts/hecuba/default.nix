{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:

# also see <https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud>

let
  meta = import ./meta.nix;
  bios = config.bootloader.firmware == "bios";
  uefi = config.bootloader.firmware == "uefi";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    inputs.arion.nixosModules.arion
    "${inputs.hecuba-services}"
    ../../modules
  ];

  inherit (meta) host;

  hardware.facter.reportPath = ./facter.json;

  bootloader = {
    enable = true;
    firmware = "uefi";
  };
  docker.enable = true;
  hardening.enable = true;
  lynis.enable = true;
  secrets.enable = true;
  ssh.enable = true;
  tailscale.enable = true;

  secrets.hecuba-gitea-runner = [ "registration_token" ];

  sops.templates."gitea-runner.env".content = ''
    TOKEN=${config.sops.placeholder."hecuba-gitea-runner/registration_token"}
  '';

  services.gitea-actions-runner.instances.hecuba = {
    enable = true;
    name = "hecuba";
    url = "https://git.hektormisplon.xyz";
    tokenFile = config.sops.templates."gitea-runner.env".path;
    labels = [ "nix:host" ];
    hostPackages = with pkgs; [
      bash
      coreutils
      git
      nix
      nodejs
      openssh
    ];
  };

  virtualisation.arion = {
    backend = "docker";
    package = pkgs.arion;
  };

  networking.hostName = config.host.name;

  boot.loader.grub.device = lib.mkIf bios "/dev/sda";
  boot.loader.systemd-boot.bootCounting.enable = lib.mkIf uefi true;

  fileSystems = lib.mkIf bios {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };
  };
  swapDevices = lib.mkIf bios [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  disko.devices.disk.main = lib.mkIf uefi {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        swap = {
          size = "4G";
          content.type = "swap";
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };

  users.users = {
    root.hashedPassword = "!";
    ${config.host.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  nix.gc.options = "--delete-older-than 14d";

  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
    flags = [ "--all" ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    kitty.terminfo
  ];

  services = {
    fail2ban = {
      enable = true;
      maxretry = 5;
    };
    journald.settings.Journal.SystemMaxUse = "500M";
  };
}
