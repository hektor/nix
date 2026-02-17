{
  config,
  inputs,
  pkgs,
  ...
}:

let
  theme = import ../../modules/stylix/theme.nix { inherit pkgs; };
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    inherit (theme)
      polarity
      base16Scheme
      override
      image
      ;
    fonts = {
      monospace = theme.monospaceFont;
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
    targets = {
      firefox = {
        profileNames = [ "default" ];
        colorTheme.enable = true;
      };
      librewolf = {
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
