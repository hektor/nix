{
  config,
  lib,
  pkgs,
  myUtils,
  ...
}:

let
  cfg = config.ssh;
  hostDir = ../../hosts;
  hostNames = myUtils.dirNames hostDir;
  hostsWithKeys = lib.filter (
    hostname: builtins.pathExists (hostDir + "/${hostname}/ssh_host.pub")
  ) hostNames;
in
{
  options.ssh.enable = lib.mkEnableOption "ssh";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ sshfs ];

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
            User = meta.deployment.targetUser;
          }
          // lib.optionalAttrs (meta.deployment.targetHost != "") {
            HostName = meta.deployment.targetHost;
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
          };
        };
    };
  };
}
