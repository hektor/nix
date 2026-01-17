{ lib, config, ... }:
with lib;
let
  cfg = config.services.openssh;
in
{
  imports = [
    ./known-hosts.nix
    ./authorized-keys.nix
    ./extract-keys.nix
  ];

  options.services.openssh.harden = mkEnableOption "harden ssh server configuration";

  config = {
    networking.firewall.allowedTCPPorts = [ 22 ];

    services.openssh.settings = optionalAttrs cfg.harden {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      ChallengeResponseAuthentication = false;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = false;
      PermitTunnel = false;
      MaxAuthTries = 3;
      LoginGraceTime = "1m";
    };
  };
}
