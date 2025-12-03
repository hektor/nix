{ pkgs, ... }:

{
  # TODO: see if this works with podman
  # TODO: check if docker/podman is enabled

  # Rootless K3S

  # FIXME
  environment.systemPackages = with pkgs; [
    k3s
    rootlesskit
    slirp4netns
  ];

  # running K3S on rootless docker was causing the following error: "failed to find cpuset cgroup (v2)" (in `docker logs k3d-lab-server-0` output)
  #
  # see <https://docs.k3s.io/advanced#known-issues-with-rootless-mode>
  # see <https://rootlesscontaine.rs/getting-started/common/cgroup2/>
  # see <https://discourse.nixos.org/t/declarative-rootless-k3s/49839>
  systemd.services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";

  # taken from <https://github.com/k3s-io/k3s/blob/main/k3s-rootless.service> as described in <https://docs.k3s.io/advanced#known-issues-with-rootless-mode#Rootless>
  systemd.user.services."k3s-rootless" = with pkgs; {
    path = with pkgs; [
      "${rootlesskit}"
      "${slirp4netns}"
      "${fuse-overlayfs}"
      "${fuse3}"
      "/run/wrappers"
    ];
    # systemd unit file for k3s (rootless)
    #
    # Usage:
    # - [Optional] Enable cgroup v2 delegation, see https://rootlesscontaine.rs/getting-started/common/cgroup2/ .
    #   This step is optional, but highly recommended for enabling CPU and memory resource limtitation.
    #
    # - Copy this file as `~/.config/systemd/user/k3s-rootless.service`.
    #   Installing this file as a system-wide service (`/etc/systemd/...`) is not supported.
    #   Depending on the path of `k3s` binary, you might need to modify the `ExecStart=/usr/local/bin/k3s ...` line of this file.
    #
    # - Run `systemctl --user daemon-reload`
    #
    # - Run `systemctl --user enable --now k3s-rootless`
    #
    # - Run `KUBECONFIG=~/.kube/k3s.yaml kubectl get pods -A`, and make sure the pods are running.
    #
    # Troubleshooting:
    # - See `systemctl --user status k3s-rootless` to check the daemon status
    # - See `journalctl --user -f -u k3s-rootless` to see the daemon log
    # - See also https://rootlesscontaine.rs/
    enable = true;
    description = "k3s (Rootless)";
    serviceConfig = {
      # NOTE: Don't try to run `k3s server --rootless` on a terminal, as it doesn't enable cgroup v2 delegation.
      # If you really need to try it on a terminal, prepend `systemd-run --user -p Delegate=yes --tty` to create a systemd scope.
      ExecStart = "${k3s}/bin/k3s server --rootless --snapshotter=fuse-overlayfs";
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
}
