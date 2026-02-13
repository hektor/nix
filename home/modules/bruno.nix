{ config, pkgs, ... }:

let
  needsNixGL = config.lib ? nixGL;
  bruno =
    if needsNixGL then
      pkgs.bruno.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/bruno --add-flags "--no-sandbox"
        '';
      })
    else
      pkgs.bruno;
in
{
  config = {
    home.packages = [ (config.nixgl.wrap bruno) ];
  };
}
