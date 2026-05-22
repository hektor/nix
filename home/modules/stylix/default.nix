{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.my.stylix;
  theme = import ../../../modules/stylix/theme.nix { inherit pkgs; };
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  options.my.stylix.enable = lib.mkEnableOption "stylix";

  config = lib.mkIf cfg.enable {
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
      targets = import ../../../modules/stylix/targets.nix;
    };
  };
}
