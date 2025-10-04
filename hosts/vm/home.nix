{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.username = "h";
  home.homeDirectory = "/home/h";

  home.file.".inputrc".source = ../../dots/.inputrc;

  programs.home-manager.enable = true;
}
