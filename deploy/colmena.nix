{
  self,
  inputs,
}:

let
  inherit (inputs.nixpkgs) lib;
  utils = import ../utils { inherit lib; };
  hostDirNames = utils.dirNames ../hosts;

  mkNode = hostname: meta: {
    imports = [ ../hosts/${hostname} ];
    deployment = {
      inherit (meta.deployment) targetHost targetUser tags;
      buildOnTarget = builtins.any (t: t != "local" && t != "arm") meta.deployment.tags;
    };
  };

  nodes = lib.genAttrs hostDirNames (hostname: mkNode hostname (utils.hostMeta ../hosts/${hostname}));
in
inputs.colmena.lib.makeHive (
  {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        localSystem = "x86_64-linux";
      };

      nodeNixpkgs = builtins.mapAttrs (_: v: v.pkgs) self.nixosConfigurations;
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
