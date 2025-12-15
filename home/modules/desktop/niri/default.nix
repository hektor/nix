{ pkgs, ... }:

{
  imports = [
    ../../fuzzel
    ../../mako
    ../../shikane
    ../../waybar
  ];

  home = {
    file.".config/niri/config.kdl".source = ./config.kdl;
    packages = with pkgs; [
      wl-clipboard
      wlsunset
    ];
  };
}
