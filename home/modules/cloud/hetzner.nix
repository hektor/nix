{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:

let
  isNixOS = osConfig != null;
in
{
  config = lib.mkIf config.cloud.hetzner.enable {
    warnings =
      lib.optional (!isNixOS)
        "hcloud module requires NixOS host configuration. This module will not work with standalone home-manager.";
    home = {
      packages = with pkgs; [ hcloud ];
    };
  };
}
