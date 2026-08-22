{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.go = {
    enable = lib.mkEnableOption "Go";
  };

  config = lib.mkIf config.go.enable {
    home = {
      sessionVariables.GOPATH = "${config.xdg.dataHome}/go";
      packages = with pkgs; [
        go
        gopls
      ];
    };
  };
}
