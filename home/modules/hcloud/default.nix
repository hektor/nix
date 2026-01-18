{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  isNixOS = osConfig != null;
in
{
  config = {
    warnings = lib.optional (!isNixOS)
      "hcloud module requires NixOS host configuration. This module will not work with standalone home-manager.";
  };
}
