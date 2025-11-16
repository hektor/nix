{
  inputs,
  config,
  pkgs,
  ...
}:

{
  system.stateVersion = "25.05";

  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.default
    ./hard.nix
    ../../modules/bootloader.nix
    ../../modules/disko.zfs-encrypted-root.nix
    ../../modules/gnome.nix
    ../../modules/bluetooth.nix
    ../../modules/keyboard
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/audio.nix
    ../../modules/printing.nix
    ../../modules/localization.nix
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
  ];

  environment.systemPackages = [ inputs.nvim.packages.x86_64-linux.nvim ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.h = import ../../home/hosts/astyanax {
      inherit inputs;
      inherit config;
      inherit pkgs;
    };
  };

  networking.hostId = "80eef97e";
  services.openssh = {
    enable = true;
    harden = true;
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    folders = {
      "/home/h/sync" = {
        id = "sync";
        devices = [ ];
      };
    };
    devices = {
      # "device1" = {
      #   id = "DEVICE-ID-GOES-HERE";
      # };
    };
  };

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };
}
