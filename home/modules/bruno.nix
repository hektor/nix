{ config, pkgs, ... }:

let
  useNixGL = config.lib ? nixGL;
  brunoBase =
    if useNixGL then
      pkgs.bruno.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/bruno --add-flags "--no-sandbox"
        '';
      })
    else
      pkgs.bruno;
  brunoFinal = if useNixGL then config.lib.nixGL.wrap brunoBase else brunoBase;
in
{
  config = {
    home.packages = [ brunoFinal ];
  };
}
