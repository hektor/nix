{
  self,
  inputs,
}:

let
  inherit (inputs.nixpkgs) lib;
  lib' = import ../lib { inherit lib; };
  # exclude hosts that need auto rollback (until `colmena` supports it) for
  # now, we use `deploy-rs` (which has magic rollback) for those (also see ./deploy-rs.nix)
  #
  # see <https://github.com/nix-community/colmena/issues/38>
  #     <https://github.com/nix-community/colmena/issues/344>
  hostnames = lib.filter (
    hostname: !((lib'.hostMeta hostname).deploy.autoRollback or false)
  ) lib'.nixosHosts;

  mkNode =
    hostname:
    let
      meta = lib'.hostMeta hostname;
      isArm = meta.system == "aarch64-linux";
    in
    {
      imports = [ ../hosts/${hostname} ];
      host.name = hostname;
      deployment = {
        inherit (meta) tags;
        targetUser = meta.host.username;
        targetHost = hostname;
        allowLocalDeployment = meta.host.admin or false;
        buildOnTarget = !isArm;
      };
    };

  nodes = lib.genAttrs hostnames mkNode;
in
inputs.colmena.lib.makeHive (
  {
    meta = {
      nixpkgs = import inputs.nixpkgs { localSystem = "x86_64-linux"; };
      specialArgs = {
        inherit inputs lib';
        outputs = self;
      };
    };
  }
  // nodes
)
