{ ... }:

{
  networking = {
    hostName = "nixos";
    wireless = {
      iwd = {
        enable = true;
      };

    };

    networkmanager = {
      wifi.backend = "iwd";
    };

    nftables.enable = true;
    firewall.enable = true;
  };
}
