{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = ../../modules/stylix/zenwritten-dark.yaml;
    override = {
      base04 = "8E8E8E"; # improved contrast
    };
    image = pkgs.runCommand "solid-bg.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
      magick -size 1x1 xc:#191919 $out
    '';
    fonts = {
      monospace = {
        package = pkgs.iosevka-bin.override { variant = "SS08"; };
        name = "Iosevka Term SS08";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
    targets = {
      firefox = {
        profileNames = [ "default" ];
        colorTheme.enable = true;
      };
      gnome.enable = false;
      gtk.enable = false;
      kitty = {
        variant256Colors = true;
      };
      nixvim.enable = false;
    };
  };
}
