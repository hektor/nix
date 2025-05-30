{ config, pkgs, ... }:

{
  system.stateVersion = "25.05";

  imports =
    [
      ./modules/bootloader.nix
      ./modules/hardware-configuration.nix # Include the results of the hardware scan.
      ./modules/networking.nix
      ./modules/users.nix
      ./modules/audio.nix
      ./modules/printing.nix
      ./modules/localization.nix
      ./modules/x.nix
    ];


  programs.git.enable = true;
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ neovim ];
}
