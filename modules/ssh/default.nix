{ lib, config, ... }:

let
  cfg = config.ssh;
in
{
  imports = [ ./hardened-openssh.nix ];

  options.ssh.enable = lib.mkEnableOption "SSH server";

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = lib.mkDefault true;
      harden = lib.mkDefault true;
    };
  };
}
