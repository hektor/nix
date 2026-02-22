{ config, lib, ... }:

let
  cfg = config.desktop;
in
{
  options.desktop = {
    ly = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    programs.niri.enable = true;

    services = {
      dbus.enable = true;
      logind.settings.Login = {
        HandleLidSwitch = "suspend";
        IdleAction = "suspend";
        IdleActionSec = 1800;
      };

      displayManager.ly = lib.mkIf cfg.ly.enable {
        enable = true;
      };
    };
  };
}
