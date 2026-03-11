{ lib, ... }:

{
  programs.waybar.style = lib.readFile ./style.css;
}
