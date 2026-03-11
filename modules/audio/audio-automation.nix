{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.audio.automation;
in
{
  options.audio.automation.enable = lib.mkEnableOption "audio automation (mute on battery)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.libnotify ];

    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{online}=="0", ACTION=="change", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="mute-audio.service"
    '';

    systemd.user.services.mute-audio = {
      description = "mute audio when switching to battery power";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.pulseaudio}/bin/pactl set-sink-mute $(${pkgs.pulseaudio}/bin/pactl get-default-sink) true && ${pkgs.libnotify}/bin/notify-send \"audio Muted\" \"switched to battery power\"'";
      };
    };
  };
}
