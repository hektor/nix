{
  config,
  lib,
  pkgs,
  myUtils,
  ...
}:

let
  cfg = config.ssh;

  hostDir = ../../../hosts;
  hostsWithKeys = lib.filter (hostname: builtins.pathExists (hostDir + "/${hostname}/ssh_host.pub")) (
    myUtils.dirNames hostDir
  );
in
{
  options.ssh.enable = lib.mkEnableOption "ssh";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ sshfs ];

    home.file.".ssh/control/.keep".text = "";

    services.ssh-agent.enable = true;

    systemd.user.services.ssh-agent.Service.Environment = [
      "SSH_ASKPASS=${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass"
      "SSH_ASKPASS_REQUIRE=prefer"
    ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings =
        lib.genAttrs hostsWithKeys (
          hostname:
          let
            meta = myUtils.hostMeta (hostDir + "/${hostname}");
          in
          {
            User = meta.host.username;
            HostName = hostname;
          }
        )
        // {
          "*" = {
            AddKeysToAgent = "yes";
            ForwardAgent = false;
            identityFile = [
              "~/.ssh/id_ed25519_sk"
              "~/.ssh/id_ed25519_sk_bak"
            ];
            IdentitiesOnly = true;
            ControlMaster = "auto";
            ControlPath = "~/.ssh/control/%C";
            ControlPersist = "10m";
          };
        };
    };
  };
}
