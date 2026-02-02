{
  outputs,
  lib,
  ...
}:
let
  nixosConfigs = builtins.attrNames outputs.nixosConfigurations;
  homeConfigs = map (n: lib.last (lib.splitString "@" n)) (
    builtins.attrNames outputs.homeConfigurations
  );
  allHosts = lib.unique (homeConfigs ++ nixosConfigs);
  hostsWithKeys = lib.filter (
    hostname: builtins.pathExists ../../hosts/${hostname}/ssh_host.pub
  ) allHosts;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = lib.genAttrs hostsWithKeys (
      hostname:
      let
        hostConfig = outputs.nixosConfigurations.${hostname}.config;
        publicHostname = hostConfig.ssh.publicHostname;
        targetUser = hostConfig.ssh.username;
      in
      {
        host = hostname;
        user = targetUser;
      }
      // lib.optionalAttrs (publicHostname != "") {
        hostname = publicHostname;
      }
    );
  };
}
