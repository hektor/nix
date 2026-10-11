{
  config,
  lib,
  pkgs,
  inputs,
  myUtils,
  paths,
  ...
}:

let
  cfg = config.deploy;

  hostNames = myUtils.dirNames paths.hosts;
  hostsWithKeys = lib.filter (
    hostname: builtins.pathExists (paths.hosts + "/${hostname}/ssh_host.pub")
  ) hostNames;

  colmena = inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena;
  deployRs = inputs.deploy-rs.packages.${pkgs.stdenv.hostPlatform.system}.default;

  hostTags = hostname: (myUtils.hostMeta (paths.hosts + "/${hostname}")).tags;
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
  };
}
