{
  services.xserver = {
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
  };

  # TODO: Declare monitors.xml
}
