{
  self,
  inputs,
}:

let
  mkNode = hostname: tags: {
    imports = [ ../hosts/${hostname} ];
    deployment = {
      targetHost = self.nixosConfigurations.${hostname}.config.ssh.publicHostname;
      targetUser = self.nixosConfigurations.${hostname}.config.ssh.username;
      buildOnTarget = builtins.any (t: t != "local") tags;
      inherit tags;
    };
  };
in
inputs.colmena.lib.makeHive {
  meta = {
    nixpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
    };

    nodeNixpkgs = builtins.mapAttrs (_: v: v.pkgs) self.nixosConfigurations;
    nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs or { }) self.nixosConfigurations;
  };

  astyanax = mkNode "astyanax" [ "local" ];
  andromache = mkNode "andromache" [ "local" ];
  vm = mkNode "vm" [ "local" ];
  hecuba = mkNode "hecuba" [ "cloud" ];
  eetion = mkNode "eetion" [ "arm" ];
}
