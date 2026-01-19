{
  inputs,
  config,
  pkgs,
  ...
}:

let
  localPackages =
    if builtins.pathExists ./packages.local.nix then
      import ./packages.local.nix { inherit inputs config pkgs; }
    else
      [ ];
in

[ ] ++ localPackages
