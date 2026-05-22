{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.photography;
in
{
  options.photography = {
    enable = lib.mkEnableOption "photography";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      darktable
    ];
  };
}
