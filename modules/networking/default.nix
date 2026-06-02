{ lib, config, ... }:

{
  options.networking.enable = lib.mkEnableOption "network configuration";

  config = lib.mkIf config.networking.enable {
    networking = {
      hostName = config.host.name;
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd";
      nftables.enable = true;
      firewall.enable = true;
    };

    services.resolved.enable = true;
  };
}
