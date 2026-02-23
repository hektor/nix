{ config, pkgs, ... }:

{
  config = {
    home.packages = [ (config.nixgl.wrap (config.wrapApp pkgs.vscode "--disable-gpu-sandbox")) ];
  };
}
