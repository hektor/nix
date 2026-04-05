{ config, ... }:

{
  networking = {
    hostName = config.host.name;
    wireless.iwd.enable = true;
    networkmanager.wifi.backend = "iwd";
    nftables.enable = true;
    firewall.enable = true;
  };
}
