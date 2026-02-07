{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.uptime-kuma;
in
{
  options.my.uptime-kuma.enable = lib.mkEnableOption "Uptime Kuma monitoring service (Docker container)";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "docker";
      containers.uptime-kuma = {
        image = "louislam/uptime-kuma:latest";
        ports = [ "127.0.0.1:3001:3001" ];
        volumes = [ "/var/lib/uptime-kuma:/app/data" ];
        environment = {
          TZ = "UTC";
          UMASK = "0022";
        };
        extraOptions = [
          "--network=proxiable"
        ];
      };
    };

    systemd.tmpfiles.settings."uptime-kuma" = {
      "/var/lib/uptime-kuma".d = {
        mode = "0755";
      };
    };

    environment.systemPackages = with pkgs; [ docker-compose ];
  };
}
