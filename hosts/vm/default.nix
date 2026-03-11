{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../modules/common
    ./hard.nix
    inputs.sops-nix.nixosModules.sops
    ./disk.nix
    ../../modules/boot/bootloader.nix
    ../../modules/keyboard
    (import ../../modules/networking { hostName = config.host.name; })
    ../../modules/users
    ../../modules/audio
    ../../modules/localization
    ../../modules/x
    ../../modules/fonts
    ../../modules/ssh
    ../../modules/storage
    (import ../../modules/secrets {
      inherit lib inputs config;
    })
  ];

  host = {
    username = "h";
    name = "vm";
  };

  home-manager.users.${config.host.username} = import ../../home/hosts/vm {
    inherit inputs config pkgs;
  };

  networking.hostName = config.host.name;
  ssh.username = config.host.username;

  secrets.username = config.host.username;

  disko = {
    devices.disk.main = {
      device = "/dev/vda";
      imageName = "nixos-vm";
      imageSize = "32G";
    };
  };

  virtualisation.vmVariantWithDisko = {
    virtualisation = {
      cores = 8;
      memorySize = 16384;
      qemu.options = [
        "-enable-kvm"
        "-cpu host"
        "-nographic"
      ];
    };
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };
}
