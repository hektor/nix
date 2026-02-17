{ pkgs }:

{
  polarity = "dark";
  base16Scheme = ./zenwritten-dark.yaml;
  override = {
    base04 = "8E8E8E";
  };
  image = pkgs.runCommand "solid-bg.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    magick -size 1x1 xc:#191919 $out
  '';
  monospaceFont = {
    package = pkgs.iosevka-bin.override { variant = "SS08"; };
    name = "Iosevka Term SS08";
  };
}
