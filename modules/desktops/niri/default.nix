{ pkgs, ... }:

{
  programs.niri.enable = true;

  services.dbus.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
  };

  services.displayManager.ly = {
    enable = true;
  };
}
