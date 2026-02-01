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

  astyanax.deployment.tags = [ "local" ];

  andromache.deployment.tags = [ "local" ];

  vm.deployment.tags = [ "local" ];

  hecuba =
    { ... }:
    {
      imports = [ ../hosts/hecuba ];
      deployment = {
        targetHost = "hecuba";
        targetUser = "username";
        targetPort = 22;
        tags = [ "cloud" ];
      };
    };

  eetion =
    { ... }:
    {
      imports = [ ../hosts/eetion ];
      deployment = {
        targetHost = "eetion";
        targetUser = "h";
        targetPort = 22;
        tags = [ "arm" ];
      };
    };
}
