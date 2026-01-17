{
  lib,
  config,
  outputs,
  ...
}:
let
  hosts = lib.attrNames outputs.nixosConfigurations;
  hostsWithKeys = lib.filter (
    hostname: builtins.pathExists ../../hosts/${hostname}/ssh_host.pub
  ) hosts;
in
{
  # auto generate known_hosts for all hosts in flake
  programs.ssh.knownHosts = lib.genAttrs hostsWithKeys (hostname: {
    publicKeyFile = ../../hosts/${hostname}/ssh_host.pub;
    extraHostNames = lib.optional (hostname == config.networking.hostName) "localhost";
  });
}
