{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.go;
in
{
  options.go = {
    enable = lib.mkEnableOption "Go";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gopls
    ];
  };
}
