{
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    IdleAction = "suspend";
    IdleActionSec = 1800;
  };
}
