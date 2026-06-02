{ lib, config, ... }:

{
  options.desktop.logind.enable = lib.mkEnableOption "logind desktop settings";

  config = lib.mkIf config.desktop.logind.enable {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      IdleAction = "suspend";
      IdleActionSec = 1800;
    };
  };
}
