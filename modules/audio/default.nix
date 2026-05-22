{ lib, config, ... }:

let
  cfg = config.audio;
in
{
  imports = [ ./audio-automation.nix ];

  options.audio.enable = lib.mkEnableOption "audio";

  config = lib.mkIf cfg.enable {
    nixpkgs.allowedUnfree = [
      "spotify"
      "spotify-unwrapped"
    ];

    security.rtkit.enable = true;

    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      pulseaudio.extraConfig = "load-module module-switch-on-connect";
    };
  };
}
