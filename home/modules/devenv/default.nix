{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.devenv;
in
{
  options.devenv = {
    enable = lib.mkEnableOption "devenv";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.devenv ];
  };
}
