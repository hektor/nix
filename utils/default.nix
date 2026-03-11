{ lib }:

{
  dirNames =
    path: builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir path));

  hostMeta = hostDir:
    if builtins.pathExists (hostDir + "/meta.nix")
    then import (hostDir + "/meta.nix")
    else throw "meta.nix required in ${hostDir}";
}
