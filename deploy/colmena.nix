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
      isLocal = builtins.elem "local" meta.tags;
    in
    {
      imports = [ ../hosts/${hostname} ];
      host.name = hostname;
      deployment = {
        inherit (meta) tags;
        targetUser = meta.host.username;
        targetHost = if isLocal then "" else hostname;
        buildOnTarget = builtins.any (t: t != "local" && t != "arm") meta.tags;
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
