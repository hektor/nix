{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.archiving;
in
{
  options.archiving.enable = lib.mkEnableOption "archiving";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      unzip
      zip
    ];
  };
}
