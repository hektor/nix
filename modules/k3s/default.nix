{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.k3s;
in
{
  options.k3s.enable = lib.mkEnableOption "k3s rootless";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      k3s
      rootlesskit
      slirp4netns
    ];

    systemd.services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";

    systemd.user.services."k3s-rootless" = {
      path = with pkgs; [
        "${rootlesskit}"
        "${slirp4netns}"
        "${fuse-overlayfs}"
        "${fuse3}"
        "/run/wrappers"
      ];
      enable = true;
      description = "k3s (Rootless)";
      serviceConfig = {
        ExecStart = "${pkgs.k3s}/bin/k3s server --rootless --snapshotter=fuse-overlayfs";
        ExecReload = "/run/current-system/sw/bin/kill -s HUP $MAINPID";
        TimeoutSec = 0;
        RestartSec = 2;
        Restart = "always";
        StartLimitBurst = 3;
        StartLimitInterval = "60s";
        LimitNOFILE = "infinity";
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        TasksMax = "infinity";
        Delegate = "yes";
        Type = "simple";
        KillMode = "mixed";
      };
      wantedBy = [ "default.target" ];
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };
  };
}
