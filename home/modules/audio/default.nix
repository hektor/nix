{ osConfig, pkgs, ... }:

{
  home.packages = with pkgs; [ pulsemixer ];

  services.mpris-proxy.enable = osConfig.hardware.bluetooth.enable or false;
}
