{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.bruno;
in
{
  options.bruno = {
    enable = lib.mkEnableOption "Bruno";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ (config.nixgl.wrap (config.wrapApp pkgs.bruno "--no-sandbox")) ];
  };
}
