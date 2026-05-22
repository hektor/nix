{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.clipboard;
in
{
  options.clipboard = {
    enable = lib.mkEnableOption "clipboard";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
