{
  myUtils,
  lib,
  pkgs,
  ...
}:
let
  hostDir = ../../hosts;
  hostNames = myUtils.dirNames hostDir;
  hostsWithKeys = lib.filter (
    hostname: builtins.pathExists (hostDir + "/${hostname}/ssh_host.pub")
  ) hostNames;
in
{
  home.packages = with pkgs; [ sshfs ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks =
      lib.genAttrs hostsWithKeys (
        hostname:
        let
          meta = myUtils.hostMeta (hostDir + "/${hostname}");
        in
        {
          host = hostname;
          user = meta.deployment.targetUser;
        }
        // lib.optionalAttrs (meta.deployment.targetHost != "") {
          hostname = meta.deployment.targetHost;
        }
      )
      // {
        "*" = {
          addKeysToAgent = "yes";
        };
      };
  };
}
