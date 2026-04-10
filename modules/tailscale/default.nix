{
  lib,
  config,
  ...
}:
{
  options.tailscale = {
    enable = lib.mkEnableOption "tailscale";
  };

  config = lib.mkIf config.tailscale.enable {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--netfilter-mode=nodivert" ];
      extraDaemonFlags = [ "--no-logs-no-support" ];
      openFirewall = false;
    };
  };
}
