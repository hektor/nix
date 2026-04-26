{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.desktop;
in
{
  imports = [ ../logind.nix ];

  options.desktop = {
    ly = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config.niri.default = lib.mkForce [
        "niri"
        "gtk"
      ];
    };

    services = {
      gnome.gnome-keyring.enable = false;
      dbus.enable = true;
      displayManager.ly = lib.mkIf cfg.ly.enable {
        enable = true;
      };
    };
  };
}
