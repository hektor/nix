{
  inputs,
  config,
  pkgs,
  ...
}:

{
  system.stateVersion = "25.05";

  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.default
    ./hard.nix
    ./disk.nix
    ../../modules/bootloader.nix
    ../../modules/keyboard
    (import ../../modules/networking.nix { hostName = "vm"; })
    ../../modules/users.nix
    ../../modules/audio.nix
    ../../modules/localization.nix
    ../../modules/x.nix
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
  ];

  environment.systemPackages = [ inputs.nvim.packages.x86_64-linux.nvim ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

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
    users.h = import ../../home/hosts/vm {
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
