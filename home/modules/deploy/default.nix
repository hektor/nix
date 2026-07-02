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
  deployRs = inputs.deploy-rs.packages.${pkgs.stdenv.hostPlatform.system}.default;

  hostTags = hostname: (myUtils.hostMeta (hostDir + "/${hostname}")).tags;
  nodeTagsDecl = ''
    declare -A _colmena_node_tags=(
    ${lib.concatMapStringsSep "\n" (
      hostname: "  [${hostname}]=${lib.escapeShellArg (lib.concatStringsSep " " (hostTags hostname))}"
    ) hostsWithKeys}
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

  deployRsWrapped = pkgs.writeShellApplication {
    name = "deploy";
    runtimeInputs = [ pkgs.openssh ];
    text = lib.replaceStrings [ "@deploy@" ] [ "${deployRs}/bin/deploy" ] (
      builtins.readFile ./deploy-rs-wrapper.bash
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

    home.packages = [
      colmenaWrapped
      deployRsWrapped
    ];
    programs.ssh.settings = lib.genAttrs hostsWithKeys (
      hostname:
      let
        meta = myUtils.hostMeta (hostDir + "/${hostname}");
      in
      {
        User = meta.host.username;
        HostName = hostname;
        ControlPath = "~/.ssh/socket-%r@%h:%p";
      }
    );
  };
}
