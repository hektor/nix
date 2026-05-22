{ lib, config, ... }:

{
  options.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop";

  config = lib.mkIf config.desktop.gnome.enable {
    services.xserver = {
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;
    };
  };
}
