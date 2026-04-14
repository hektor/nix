{ lib }:

let
  hosts = import ./hosts.nix;
  secrets = import ./secrets.nix { inherit lib; };
in
{
  dirNames =
    path: builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir path));
}
// hosts
// secrets
