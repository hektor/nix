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
    niri = {
      enable = lib.mkEnableOption "niri desktop";
    };
    ly = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.niri.enable {
    desktop.logind.enable = lib.mkDefault true;
    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    programs.xwayland.enable = true;

    environment = {
      systemPackages = [ pkgs.xwayland-satellite ];
      sessionVariables.NIXOS_OZONE_WL = "1";
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

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

    services = {
      gnome.gnome-keyring.enable = false;
      dbus.enable = true;
      displayManager.ly = lib.mkIf cfg.ly.enable {
        enable = true;
      };
    };
  };
}
