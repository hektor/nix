{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nfc;
in
{
  options.nfc = {
    enable = lib.mkEnableOption "NFC tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.proxmark3.override { withGeneric = true; })
    ];
  };
}
