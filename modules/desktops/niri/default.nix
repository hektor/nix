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

    #  error:
    #  Failed assertions:
    #  - h profile: xdg.portal: since you installed Home Manager via its NixOS module and
    #  'home-manager.useUserPackages' is enabled, you need to add
    #
    #  environment.pathsToLink = [ `/share/applications` `/share/xdg-desktop-portal` ];
    #
    #  to your NixOS configuration so that the portal definitions and DE
    #  provided configurations get linked.
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
