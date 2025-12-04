{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  username = "h";
in
{
  imports = [
    ../../modules/common
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.default
    ./hard.nix
    ./disk.nix
    ../../modules/boot/bootloader.nix
    ../../modules/keyboard
    (import ../../modules/networking.nix { hostName = "vm"; })
    ../../modules/users
    ../../modules/audio
    ../../modules/localization
    ../../modules/x
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
    (import ../../modules/secrets {
      inherit lib;
      inherit inputs;
      inherit config;
    })
  ];

  secrets.username = "h";

  environment.systemPackages = [ inputs.nvim.packages.x86_64-linux.nvim ];

  disko = {
    devices.disk.main.device = "/dev/vda";
    devices.disk.main.imageName = "nixos-vm";
    devices.disk.main.imageSize = "32G";
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../home/hosts/vm {
      inherit inputs;
      inherit config;
      inherit pkgs;
    };
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  services.openssh = {
    enable = true;
    harden = true;
  };
}
