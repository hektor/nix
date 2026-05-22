{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.docker;
in
{
  options.docker = {
    enable = lib.mkEnableOption "Docker";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dive
    ];
  };
}
