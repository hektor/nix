{
  self,
  inputs,
}:

let
  inherit (inputs.nixpkgs) lib;
  utils = import ../utils { inherit lib; };
  hostnames = utils.dirNames ../hosts;

  mkNode =
    hostname:
    let
      meta = utils.hostMeta ../hosts/${hostname};
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
        inherit inputs;
        outputs = self;
        dotsPath = ../dots;
        myUtils = utils;
      };
    };
  }
  // nodes
)
