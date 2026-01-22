{
  programs.niri.enable = true;

  services.dbus.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    IdleAction = "suspend";
    IdleActionSec = 1800;
  };

  services.displayManager.ly = {
    enable = true;
  };
}
