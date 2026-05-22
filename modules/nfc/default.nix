{ config, lib, ... }:

let
  cfg = config.nfc;
  inherit (config.host) username;
in
{
  options.nfc = {
    enable = lib.mkEnableOption "NFC";
  };
  config = lib.mkIf cfg.enable {
    users.users.${username}.extraGroups = [ "dialout" ];
  };
}
