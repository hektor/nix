{ pkgs, ... }:

{
  home.username = "hektor";
  home.homeDirectory = "/home/hektor";
  home.stateVersion = "25.05";

  home.packages = import ./packages.nix { inherit pkgs; };
}
