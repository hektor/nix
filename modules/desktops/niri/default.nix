{
  programs.niri.enable = true;

  services = {
    dbus.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      IdleAction = "suspend";
      IdleActionSec = 1800;
    };

    displayManager.ly = {
      enable = true;
    };
  };
}
