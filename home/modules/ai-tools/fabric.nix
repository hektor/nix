{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.ai-tools.fabric = {
    enable = lib.mkEnableOption "fabric";
  };

  config = lib.mkIf config.ai-tools.fabric.enable {
    home.packages = [ pkgs.fabric-ai ];
  };
}
