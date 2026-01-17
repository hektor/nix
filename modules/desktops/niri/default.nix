{ pkgs, ... }:

{
  programs.niri.enable = true;

  services.dbus.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
  };
  xdg = {
    portal.enable = true;
    portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  services.displayManager.ly = {
    enable = true;
  };
}
