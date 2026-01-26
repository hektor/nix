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
  hostName = "vm";
in
{
  imports = [
    ../../modules/common
    ./hard.nix
    inputs.sops-nix.nixosModules.sops
    ./disk.nix
    ../../modules/boot/bootloader.nix
    ../../modules/keyboard
    (import ../../modules/networking { inherit hostName; })
    ../../modules/users
    ../../modules/audio
    ../../modules/localization
    ../../modules/x
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
    (import ../../modules/secrets {
      inherit lib inputs config;
    })
  ];

  home-manager.users.${username} = import ../../home/hosts/vm {
    inherit inputs config pkgs;
  };

  networking.hostName = hostName;
  ssh.username = username;

  secrets.username = username;

  environment.systemPackages = [ inputs.nvim.packages.x86_64-linux.nvim ];

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
    openssh = {
      enable = true;
      harden = true;
    };
  };
}
