{
  config,
  lib,
  pkgs,
  dotsPath,
  myUtils,
  osConfig ? null,
  inputs ? null,
  ...
}:

let
  sops = myUtils.sopsAvailability config osConfig;
  standalone = osConfig == null;
in
lib.optionalAttrs standalone {
  sops = {
    secrets = myUtils.mkSopsSecrets "${toString inputs.nix-secrets}/secrets" "taskwarrior" [
      "sync-server-url"
      "sync-server-client-id"
      "sync-encryption-secret"
    ] { };

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
    lib.optional (!sops.available && config.programs.taskwarrior.enable)
      "taskwarrior is enabled, but sops templates are not available. taskwarrior sync will not be configured.";

  home.packages = with pkgs; [
    libnotify
    taskopen
    python3
  ];

  home.file = {
    ".config/task/taskrc" = {
      force = true;
      source = dotsPath + "/.config/task/taskrc";
    };
    ".config/task/taskrc.d/aliases".source = dotsPath + "/.config/task/taskrc.d/aliases";
    ".config/task/taskrc.d/colors".source = dotsPath + "/.config/task/taskrc.d/colors";
    ".config/task/taskrc.d/contexts".source = dotsPath + "/.config/task/taskrc.d/contexts";
    ".config/task/taskrc.d/reports".source = dotsPath + "/.config/task/taskrc.d/reports";
    ".config/task/taskrc.d/udas".source = dotsPath + "/.config/task/taskrc.d/udas";
    ".config/task/taskrc.d/urgency".source = dotsPath + "/.config/task/taskrc.d/urgency";
    ".local/share/task/hooks/on-exit.sync.py" = {
      source = dotsPath + "/.local/share/task/hooks/on-exit.sync.py";
    };
    ".local/share/task/hooks/on-add.limit.py" = {
      source = dotsPath + "/.local/share/task/hooks/on-add.limit.py";
      executable = true;
    };
    ".local/share/task/hooks/on-modify.limit.py" = {
      source = dotsPath + "/.local/share/task/hooks/on-modify.limit.py";
      executable = true;
    };
    ".local/share/task/scripts/sync-and-notify.sh" = {
      source = dotsPath + "/.local/share/task/scripts/sync-and-notify.sh";
      executable = true;
    };
  };

  programs.taskwarrior = with pkgs; {
    enable = true;
    package = taskwarrior3;
    colorTheme = "dark-256";
    config = {
      recurrence = "off";
    };
    extraConfig = lib.optionalString sops.available ''
      include ${sops.templates."taskrc.d/sync".path}
    '';
  };
}
