{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.username = "h";
  home.homeDirectory = "/home/h";

  programs = {
    home-manager.enable = true;
    git.enable = true;
    firefox.enable = true;
  };

  home.packages = with pkgs; [
    kitty
    neovim
  ];

  home.file.".inputrc".source = ../../dots/.inputrc;
}
