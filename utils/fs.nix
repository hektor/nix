{ lib }:

{
  dirNames =
    path: builtins.attrNames (lib.filterAttrs (_: t: t == "directory") (builtins.readDir path));
}
