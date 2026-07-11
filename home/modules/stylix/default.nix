{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.stylix;
  theme = import ../../../modules/stylix/theme.nix { inherit pkgs; };
in
{
  options.my.stylix.enable = lib.mkEnableOption "stylix";

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      inherit (theme)
        polarity
        base16Scheme
        override
        image
        fonts
        ;
      targets = import ../../../modules/stylix/targets.nix;
    };
  };
}
