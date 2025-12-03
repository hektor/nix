{
  hostName ? "nixos",
  ...
}:

{
  networking = {
    hostName = hostName;
    wireless.iwd.enable = true;
    networkmanager.wifi.backend = "iwd";
    nftables.enable = true;
    firewall.enable = true;
  };
}
