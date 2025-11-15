{ ... }:

{
  system.stateVersion = "25.05";

  imports = [
    ./hard.nix
    ../../modules/bootloader.nix
    ../../modules/disko.zfs-encrypted-root.nix
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.h = ../../home/hosts/astyanax;
  };

  networking.hostId = "80eef97e";
  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh = {
    enable = true;
    harden = true;
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };
}
