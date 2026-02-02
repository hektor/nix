{
  self,
  inputs,
}:

inputs.colmena.lib.makeHive {
  meta = {
    nixpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
    };

    nodeNixpkgs = builtins.mapAttrs (_: v: v.pkgs) self.nixosConfigurations;
    nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs or { }) self.nixosConfigurations;
  };

  astyanax = {
    imports = [ ../hosts/astyanax ];
    deployment.tags = [ "local" ];
  };

  andromache = {
    imports = [ ../hosts/andromache ];
    deployment.tags = [ "local" ];
  };

  vm = {
    imports = [ ../hosts/vm ];
    deployment.tags = [ "local" ];
  };

  hecuba = {
    imports = [ ../hosts/hecuba ];
    deployment = {
      targetHost = "server.hektormisplon.xyz";
      targetUser = "username";
      tags = [ "cloud" ];
    };
  };

  eetion = {
    imports = [ ../hosts/eetion ];
    deployment = {
      targetUser = "h";
      tags = [ "arm" ];
    };
  };
}
