{
  config,
  lib,
  pkgs,
  myUtils,
  osConfig ? null,
  inputs ? null,
  ...
}:

let
  cfg = config.taskwarrior;
  sops = myUtils.sopsAvailability config osConfig;
  standalone = osConfig == null;

  syncHook = pkgs.writers.writePython3 "on-exit.sync.py" { flakeIgnore = [ "E501" ]; } ''
    # Source: <https://gist.github.com/danmou/83079feac22307813178d7f8c456c544>

    # This hook syncs Taskwarrior to the configured task server without blocking.
    # The on-exit event is triggered once, after all processing is complete.

    import json
    import subprocess
    import sys

    try:
        json.loads(sys.stdin.readline())
    except json.JSONDecodeError:
        # No input
        pass

    # hooks=0 ensures that the sync command doesn't call the on-exit hook.
    # verbose=nothing sets the verbosity to print nothing at all.
    subprocess.Popen(
        ["${lib.getExe pkgs.taskwarrior3}", "rc.hooks=0", "sync"],
        stdin=subprocess.PIPE,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    sys.exit(0)
  '';

  syncAndNotify = pkgs.writeShellApplication {
    name = "sync-and-notify";
    runtimeInputs = [
      pkgs.libnotify
      pkgs.taskwarrior3
    ];
    text = ''
      # Redirect both stdout and stderr to notify-send as is, but set
      # urgency to critical if the command fails.
      if output="$(task rc.hooks=0 sync 2>&1)"; then
        urgency=normal
      else
        urgency=critical
      fi
      notify-send -u "$urgency" "Taskwarrior sync" "$output"
    '';
  };
in
{
  options.taskwarrior.enable = lib.mkEnableOption "taskwarrior";

  config = lib.mkIf cfg.enable (
    lib.optionalAttrs standalone {
      sops = {
        secrets = myUtils.mkSopsSecrets "${toString inputs.nix-secrets}/secrets" {
          taskwarrior = [
            "sync-server-url"
            "sync-server-client-id"
            "sync-encryption-secret"
          ];
        };

        templates."taskrc.d/sync" = {
          content = ''
            sync.server.url=${config.sops.placeholder."taskwarrior/sync-server-url"}
            sync.server.client_id=${config.sops.placeholder."taskwarrior/sync-server-client-id"}
            sync.encryption_secret=${config.sops.placeholder."taskwarrior/sync-encryption-secret"}
          '';
        };
      };
    }
    // {
      warnings =
        lib.optional (!sops.available)
          "taskwarrior is enabled, but sops templates are not available. taskwarrior sync will not be configured.";

      home.packages = [ pkgs.taskopen ];
      home.file = {
        ".config/task/taskrc".text = ''
          include ${config.xdg.configHome}/task/home-manager-taskrc
        '';
        ".local/share/task/hooks/on-exit.sync.py".source = syncHook;
        ".local/share/task/scripts/sync-and-notify.sh".source = lib.getExe syncAndNotify;
      };

      programs.taskwarrior = {
        enable = true;
        package = pkgs.taskwarrior3;
        colorTheme = "dark-256";
        config = {
          # taskrc.d/aliases
          "alias.a" = "add";
          "alias.burndown" = "burndown.daily";
          "alias.e" = "modify";
          "alias.rm" = "delete";

          # taskrc.d/colors
          "color.active" = "bold white on black";
          "color.alternate" = "";
          "color.blocked" = "gray15";
          "color.blocking" = "bold";
          "color.due" = "";
          "color.due.today" = "";
          "color.overdue" = "";
          "color.scheduled" = "";
          "color.uda.priority.H" = "bold";
          "color.uda.priority.L" = "";
          "color.uda.priority.M" = "";
          "color.until" = "";

          # taskrc.d/contexts
          "context.home.read" = "project:home";
          "context.home.write" = "project:home";
          "context.studies.read" = "project:studies";
          "context.studies.write" = "project:studies";
          "context.work.read" = "tags:work";

          # taskrc.d/reports
          "report.in.columns" = "id,description";
          "report.in.description" = "Inbox (untagged)";
          "report.in.filter" = "status:pending tags.none:";
          "report.in.labels" = "ID,Description";
          "report.in.sort" = "entry+";
          "report.minimal.columns" = "id,description";
          "report.minimal.labels" = ",";
          "report.next.columns" =
            "id,start.age,entry.age,depends,project,tags,scheduled.countdown,due.relative,until.remaining,description";
          "report.next.filter" = "status:pending -WAITING -BLOCKED limit:page";
          "report.next.labels" = "ID,Active,Age,Deps,Project,Tag,S,Due,Until,Description";
          "report.recent.columns" = "id,description,entry";
          "report.recent.description" = "Recently added";
          "report.recent.labels" = "ID,Description,Age";
          "report.recent.sort" = "entry+";

          # taskrc.d/udas
          "uda.url.label" = "URL";
          "uda.url.type" = "string";

          # taskrc.d/urgency
          "urgency.uda.priority.L.coefficient" = "-1.0";
          "urgency.user.project.admin.coefficient" = "1.0";
          "urgency.user.project.creative.coefficient" = "0.0";
          "urgency.user.project.groceries.coefficient" = "0.5";
          "urgency.user.project.home.coefficient" = "0.2";
          "urgency.user.project.personal.coefficient" = "0.5";
          "urgency.user.project.side.coefficient" = "0.0";
          "urgency.user.project.studies.coefficient" = "1.0";

          # misc
          "news.version" = "3.4.2";
          "rc.json.array" = "on";
          "rc.verbose" = "nothing";
          "search.case.sensitive" = "no";
          "recurrence" = "off";
          "reserved.lines" = "3";
        };
        extraConfig = lib.optionalString sops.available ''
          include ${sops.templates."taskrc.d/sync".path}
        '';
      };
    }
  );
}
