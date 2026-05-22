{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.fonts;
in
{
  imports = [ ./iosevka.nix ];

  options.my.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
        dejavu_fonts
        liberation_ttf
        noto-fonts-color-emoji
      ];
    };
  };
}
