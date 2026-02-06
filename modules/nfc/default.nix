{ config, lib, ... }:

let
  cfg = config.nfc;
in
{
  options.nfc = {
    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
  config = lib.mkIf (cfg.user != null) {
    users.users.${cfg.user}.extraGroups = [ "dialout" ];
  };
}
