{
  hostMeta =
    hostDir:
    if builtins.pathExists (hostDir + "/meta.nix") then
      import (hostDir + "/meta.nix")
    else
      throw "meta.nix required in ${hostDir}";
}
