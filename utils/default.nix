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

  sopsAvailability =
    config: osConfig:
    let
      hmSopsAvailable = config ? sops && config.sops ? secrets;
      osSopsAvailable = osConfig != null && osConfig ? sops && osConfig.sops ? secrets;
    in
    {
      available = hmSopsAvailable || osSopsAvailable;
      secrets = if hmSopsAvailable then config.sops.secrets else osConfig.sops.secrets;
      templates = if hmSopsAvailable then config.sops.templates else osConfig.sops.templates;
    };
}
