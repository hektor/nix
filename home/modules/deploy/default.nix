{
  config,
  lib,
  pkgs,
  inputs,
  myUtils,
  ...
}:

let
  cfg = config.deploy;

  hostDir = ../../../hosts;
  hostNames = myUtils.dirNames hostDir;
  hostsWithKeys = lib.filter (
    hostname: builtins.pathExists (hostDir + "/${hostname}/ssh_host.pub")
  ) hostNames;

  colmena = inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena;

  hostTags = hostname: (myUtils.hostMeta (hostDir + "/${hostname}")).tags;
  remoteHostsWithKeys = lib.filter (
    hostname: !(builtins.elem "local" (hostTags hostname))
  ) hostsWithKeys;
  nodeTagsDecl = ''
    declare -A _colmena_node_tags=(
    ${lib.concatMapStringsSep "\n" (
      hostname: "  [${hostname}]=${lib.escapeShellArg (lib.concatStringsSep " " (hostTags hostname))}"
    ) remoteHostsWithKeys}
    )
  '';

  colmenaWrapped = pkgs.writeShellApplication {
    name = "colmena";
    runtimeInputs = [ pkgs.openssh ];
    text =
      nodeTagsDecl
      + lib.replaceStrings [ "@colmena@" ] [ "${colmena}/bin/colmena" ] (
        builtins.readFile ./colmena-wrapper.bash
      );
  };
in
{
  options.deploy.enable = lib.mkEnableOption "deploy";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.ssh.enable;
        message = "'home/modules/deploy' requires 'home/modules/ssh'";
      }
    ];

    home.packages = [ colmenaWrapped ];
    programs.ssh.settings = lib.genAttrs hostsWithKeys (
      hostname:
      let
        meta = myUtils.hostMeta (hostDir + "/${hostname}");
        isLocal = builtins.elem "local" meta.tags;
      in
      {
        User = meta.host.username;
      }
      // lib.optionalAttrs (!isLocal) {
        HostName = hostname;
        ControlPath = "~/.ssh/socket-%r@%h:%p";
      }
    );
  };
}
