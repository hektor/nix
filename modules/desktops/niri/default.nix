{ pkgs, ... }:

{
  programs.niri.enable = true;

  services.dbus.enable = true;
  xdg = {
    portal.enable = true;
  };

  environment.systemPackages = with pkgs; [ wlsunset ];
}
