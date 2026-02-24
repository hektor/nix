{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.go = {
    enable = lib.mkEnableOption "go language";
  };

  config = lib.mkIf config.go.enable {
    home.packages = with pkgs; [
      go
      gopls
    ];
  };
}
