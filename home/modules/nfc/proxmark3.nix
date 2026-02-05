{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nfc.proxmark3;
in
{
  options.nfc.proxmark3 = {
    enable = lib.mkEnableOption "proxmark3 (iceman fork)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.proxmark3
    ];
  };
}
