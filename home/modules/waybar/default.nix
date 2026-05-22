{
  config,
  lib,
  ...
}:

let
  cfg = config.waybar;
in
{
  imports = [
    ./settings.nix
    ./style.nix
  ];

  options.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
  };
}
