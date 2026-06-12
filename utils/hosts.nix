{ lib }:

let
  fs = import ./fs.nix { inherit lib; };
in
{
  hostMeta =
    hostDir:
    if builtins.pathExists (hostDir + "/meta.nix") then
      import (hostDir + "/meta.nix")
    else
      throw "meta.nix required in ${toString hostDir}";

  adminHosts =
    hostsPath:
    builtins.filter (host: ((import (hostsPath + "/${host}/meta.nix")).host.admin or false)) (
      fs.dirNames hostsPath
    );
}
