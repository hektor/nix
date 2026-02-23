{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.firewall = {
    enable = mkEnableOption "firewall";

    allowedTCPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
    };

    allowedUDPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
    };
  };

  config = lib.mkIf config.firewall.enable {
    networking.firewall = {
      enable = true;
      inherit (config.firewall) allowedTCPPorts allowedUDPPorts;
    };
  };
}
