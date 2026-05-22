{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.vscode;
in
{
  options.vscode = {
    enable = lib.mkEnableOption "Visual Studio Code";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ (config.nixgl.wrap (config.wrapApp pkgs.vscode "--no-sandbox")) ];
  };
}
