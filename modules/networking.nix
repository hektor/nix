{ ... }:

{
  networking.hostName = "nixos";
  networking.wireless = { iwd = { enable = true; }; };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
}
