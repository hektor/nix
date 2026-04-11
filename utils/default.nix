{ lib }:

{
  dirNames =
    path: builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir path));

  hostMeta =
    hostDir:
    if builtins.pathExists (hostDir + "/meta.nix") then
      import (hostDir + "/meta.nix")
    else
      throw "meta.nix required in ${hostDir}";

  mkSopsSecrets =
    sopsDir: group: names: extraOpts:
    let
      file = "${group}.yaml";
    in
    lib.foldl' lib.mergeAttrs { } (
      map (name: {
        "${group}/${name}" = {
          sopsFile = "${sopsDir}/${file}";
          key = name;
        }
        // extraOpts;
      }) names
    );

  sopsAvailability =
    config: osConfig:
    let
      osSopsAvailable = osConfig != null && osConfig ? sops && osConfig.sops ? secrets;
      hmSopsAvailable = config ? sops && config.sops ? secrets;
      preferOs = osSopsAvailable;
    in
    {
      available = osSopsAvailable || hmSopsAvailable;
      secrets = if preferOs then osConfig.sops.secrets else config.sops.secrets;
      templates = if preferOs then osConfig.sops.templates else config.sops.templates;
    };
}
