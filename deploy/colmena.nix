{
  self,
  inputs,
}:

let
  inherit (inputs.nixpkgs) lib;
  utils = import ../utils { inherit lib; };
  hostDirNames = utils.dirNames ../hosts;

  mkNode = hostname: tags: {
    imports = [ ../hosts/${hostname} ];
    deployment = {
      targetHost = self.nixosConfigurations.${hostname}.config.ssh.publicHostname;
      targetUser = self.nixosConfigurations.${hostname}.config.ssh.username;
      buildOnTarget = builtins.any (t: t != "local") tags;
      inherit tags;
    };
  };

  nodes = lib.genAttrs hostDirNames (hostname:
    mkNode hostname (utils.hostMeta ../hosts/${hostname}).deployment.tags
  );
in
inputs.colmena.lib.makeHive {
  meta = {
    nixpkgs = import inputs.nixpkgs {
      localSystem = "x86_64-linux";
    };

    nodeNixpkgs = builtins.mapAttrs (_: v: v.pkgs) self.nixosConfigurations;
    nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs or { }) self.nixosConfigurations;
  };

  inherit nodes;
}
