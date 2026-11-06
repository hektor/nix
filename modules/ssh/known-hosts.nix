{
  lib,
  config,
  lib',
  ...
}:

let
  hosts = lib'.nixosHosts;
  keyPath = hostname: lib'.hostsPath + "/${hostname}/ssh_host.pub";
  hostsWithKeys = lib.filter (hostname: builtins.pathExists (keyPath hostname)) hosts;
in
{
  config = lib.mkIf config.ssh.enable {
    programs.ssh.knownHosts = lib.genAttrs hostsWithKeys (hostname: {
      publicKeyFile = keyPath hostname;
      extraHostNames = lib.optional (hostname == config.networking.hostName) "localhost";
    });
  };
}
