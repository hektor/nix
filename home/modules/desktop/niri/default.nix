{ pkgs, ... }:

{
  imports = [
    ../../clipboard
    ../../fuzzel
    ../../mako
    ../../shikane
    ../../waybar
  ];

  options.desktop.niri.enable = lib.mkEnableOption "niri desktop environment";

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
}
