{ lib }:

let
  fs = import ./fs.nix { inherit lib; };

  hostsPath = ../hosts;
  hostMeta =
    host:
    let
      metaPath = hostsPath + "/${host}/meta.nix";
    in
    if builtins.pathExists metaPath then
      import metaPath
    else
      throw "meta.nix required in ${toString metaPath}";
  hostNames = fs.dirNames hostsPath;
in
{
  inherit hostsPath hostMeta hostNames;

  adminHosts = builtins.filter (host: (hostMeta host).host.admin or false) hostNames;
  nixosHosts = hostNames;
}
