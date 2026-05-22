{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  cfg = config.audio;
in
{
  options.audio.enable = lib.mkEnableOption "audio";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ pulsemixer ];
    services.mpris-proxy.enable = osConfig.hardware.bluetooth.enable or false;
  };
}
