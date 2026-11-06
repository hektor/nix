{
  inputs,
  lib',
  config,
  lib,
  ...
}:

let
  homeDir = ../../home/hosts + "/${config.host.name}";
in
{
  imports = [ inputs.home-manager.nixosModules.default ];

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        inputs
        lib'
        ;
    };
    sharedModules = [
      {
        host.username = lib.mkDefault config.host.username;
      }
    ];
    users = lib.optionalAttrs (builtins.pathExists homeDir) {
      ${config.host.username} = import homeDir;
    };
  };
}
