{ config, pkgs, ... }:

let
  needsNixGL = config.lib ? nixGL;
  vscode =
    if needsNixGL then
      pkgs.vscode.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/code --add-flags "--disable-gpu-sandbox"
        '';
      })
    else
      pkgs.vscode;
in
{
  config = {
    home.packages = [ (config.nixgl.wrap vscode) ];
  };
}
