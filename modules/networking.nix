{ ... }:

{
  networking.hostName = "nixos";
  networking.wireless = {
    iwd = {
      enable = true;
    };
  };
  networking = {
    nftables.enable = true;
    firewall.enable = true;
  };
}
