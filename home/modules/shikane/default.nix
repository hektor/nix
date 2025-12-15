{ pkgs, ... }:

{
  home.packages = with pkgs; [ wdisplays ];
  services.shikane.enable = true;
}
