{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.stylix;
  theme = import ./theme.nix { inherit pkgs; };
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  options.my.stylix.enable = lib.mkEnableOption "stylix theming";

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
      autoEnable = true;
    };

    home-manager.sharedModules = [
      {
        stylix.targets = import ./targets.nix;
      }
    ];
  };
}
