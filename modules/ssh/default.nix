{ lib, ... }:

{
  imports = [ ./hardened-openssh.nix ];

  config.services.openssh = {
    enable = lib.mkDefault true;
    harden = lib.mkDefault true;
  };
}
