{
  config,
  lib,
  pkgs,
  ...
}:

let
  status =
    name: args:
    lib.getExe (
      pkgs.writeShellApplication (
        {
          inherit name;
          text = builtins.readFile ./scripts/${name};
        }
        // args
      )
    );
in
{
  programs.waybar.settings = [
    (
      {
        height = 16;
        spacing = 4;
        modules-left = [ "niri/workspaces" ];
        modules-right = [
          "custom/project"
          "custom/pomo"
        ]
        ++ lib.optional config.taskwarrior.enable "custom/tasks"
        ++ lib.optional config.anki.enable "custom/anki"
        ++ [
          "pulseaudio"
          "memory"
          "cpu"
          "network"
          "clock"
          "battery"
        ];
        clock = {
          format = "W{:%V %d %b %H:%M}";
          tooltip-format = "{calendar}";
          format-alt = "{:%Y-%m-%d %H:%M:%S}";
        };
        battery = {
          bat = "BAT0";
          adapter = "ADP1";
          interval = 5;
          full-at = 99;
          states = {
            good = 80;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}%--";
          format-charging = "{capacity}%++";
          format-plugged = "{capacity}%";
          format-alt = "{time} {power}W";
        };
        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "muted";
          on-click = "pavucontrol";
        };
        memory = {
          interval = 2;
          format = "RAM {percentage}%";
          format-alt = "RAM {used:0.1f}G/{total:0.1f}G";
        };
        cpu = {
          interval = 2;
          format = "CPU {usage}%";
          format-alt = "CPU {avg_frequency}GHz";
        };
        network = {
          interval = 5;
          format-wifi = "{ifname} {ipaddr} {essid}";
          format-ethernet = "{ifname} {ipaddr}";
          format-disconnected = "{ifname} disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };
        "custom/project" = {
          exec = status "sb-project" { runtimeInputs = [ pkgs.coreutils ]; };
          interval = 30;
        };
        "custom/pomo" = {
          exec = status "sb-pomo" { runtimeInputs = [ pkgs.coreutils ]; };
          interval = 1;
        };
      }
      // lib.optionalAttrs config.taskwarrior.enable {
        "custom/tasks" = {
          exec = status "sb-tasks" { runtimeInputs = [ config.programs.taskwarrior.package ]; };
          interval = 60;
        };
      }
      // lib.optionalAttrs config.anki.enable {
        "custom/anki" = {
          exec = status "sb-anki" {
            runtimeInputs = with pkgs; [
              coreutils
              curl
              gawk
              jq
            ];
            runtimeEnv.ANKI_REVIEWS = config.anki.reviewsCache;
          };
          interval = 300;
        };
      }
    )
  ];
}
