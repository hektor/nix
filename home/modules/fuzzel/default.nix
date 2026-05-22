{
  config,
  lib,
  ...
}:

let
  cfg = config.fuzzel;
in
{
  options.fuzzel.enable = lib.mkEnableOption "fuzzel";

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          horizontal-pad = 0;
          vertical-pad = 0;
        };
        border = {
          width = 2;
          radius = 0;
        };
      };
    };
  };
}
