{
  self,
  inputs,
}:

let
  inherit (inputs.nixpkgs) lib;
  utils = import ../utils { inherit lib; };

  # only include hosts that need auto rollback (until `colmena` supports it)
  # `colmena` is used for other hosts (see ./colmena.nix)
  hostnames = lib.filter (
    hostname: (utils.hostMeta ../hosts/${hostname}).deploy.autoRollback or false
  ) (utils.dirNames ../hosts);

  mkNode =
    hostname:
    let
      meta = utils.hostMeta ../hosts/${hostname};
    in
    {
      inherit hostname;
      sshUser = meta.host.username;
      magicRollback = true;
      autoRollback = true;
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.${meta.system}.activate.nixos self.nixosConfigurations.${hostname};
      };
    };
in
{
  nodes = lib.genAttrs hostnames mkNode;
}
