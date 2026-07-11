{ pkgs }:

let
  monospaceFont = {
    package = pkgs.iosevka-bin.override { variant = "SS08"; };
    name = "Iosevka Term SS08";
  };
in
{
  polarity = "dark";
  base16Scheme = ./zenwritten-dark.yaml;
  override = {
    base04 = "8E8E8E";
  };
  image = pkgs.runCommand "solid-bg.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    magick -size 1x1 xc:#191919 $out
  '';
  inherit monospaceFont;
  fonts = {
    monospace = monospaceFont;
    serif = monospaceFont;
    sansSerif = monospaceFont;
    emoji = monospaceFont;
  };
}
