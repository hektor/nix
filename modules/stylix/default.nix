{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = ../stylix/zenwritten-dark.yaml;
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
    autoEnable = true;
  };

  home-manager.sharedModules = [
    {
      stylix.targets = {
        firefox.profileNames = [ "default" ];
      };
    }
  ];
}
