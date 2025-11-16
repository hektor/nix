{ lib, config, ... }:
with lib;
let
  cfg = config.services.openssh;
in
{
  options.services.openssh.harden = mkEnableOption "harden ssh server configuration";
  config = {
    networking.firewall.allowedTCPPorts = [ 22 ];
    services.openssh.settings = optionalAttrs cfg.harden {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
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
