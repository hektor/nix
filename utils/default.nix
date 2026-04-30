{ lib }:

let
  fs = import ./fs.nix { inherit lib; };
  hosts = import ./hosts.nix { inherit lib; };
  secrets = import ./secrets.nix { inherit lib; };
in
fs // hosts // secrets
