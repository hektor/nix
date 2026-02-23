{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.wol = {
    enable = mkEnableOption "Wake-on-LAN configuration";

    interfaces = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            macAddress = mkOption {
              type = types.str;
              example = "02:68:b3:29:da:98";
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf config.wol.enable {
    networking.interfaces = lib.mapAttrs (_: iface: {
      wakeOnLan.enable = true;
      inherit (iface) macAddress;
    }) config.wol.interfaces;

    # firewall.allowedUDPPorts = [ 9 ];
  };
}
