{ lib, ... }:

{
  imports =
    let
      dirs = lib.attrNames (lib.filterAttrs (_: v: v == "directory") (builtins.readDir ./.));
      hasDef = name: builtins.pathExists ./${name}/default.nix;
    in
    map (name: ./${name}) (builtins.filter hasDef dirs);
}
