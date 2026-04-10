{ pkgs, ... }:

{
  imports = [
    ../../clipboard
    ../../fuzzel
    ../../mako
    ../../shikane
    ../../waybar
  ];

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
}
