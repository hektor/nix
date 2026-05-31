{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ../../clipboard
    ../../fuzzel
    ../../mako
    ../../shikane
    ../../waybar
  ];

  options.desktop.niri.enable = lib.mkEnableOption "niri desktop";

  config = lib.mkIf config.desktop.niri.enable {
    clipboard.enable = lib.mkDefault true;
    fuzzel.enable = lib.mkDefault true;
    mako.enable = lib.mkDefault true;
    shikane.enable = lib.mkDefault true;
    waybar.enable = lib.mkDefault true;

    home = {
      file.".config/niri/config.kdl".source = ./config.kdl;
      packages = with pkgs; [
        brightnessctl
        wlsunset
      ];
    };

    services.gammastep = {
      enable = true;
      provider = "manual";
      latitude = 51.05;
      longitude = 3.71667;
    };

    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';

    xdg.portal = {
      enable = true;
      config = {
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Settings" = [
            "gnome"
            "gtk"
          ];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
