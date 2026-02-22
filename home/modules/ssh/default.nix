{
  outputs,
  lib,
  pkgs,
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
  home.packages = with pkgs; [ sshfs ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks =
      lib.genAttrs hostsWithKeys (
        hostname:
        let
          hostConfig = outputs.nixosConfigurations.${hostname}.config;
          inherit (hostConfig.ssh) publicHostname username;
        in
        {
          host = hostname;
          user = username;
        }
        // lib.optionalAttrs (publicHostname != "") {
          hostname = publicHostname;
        }
      )
      // {
        "*" = {
          addKeysToAgent = "yes";
        };
      };
  };
}
