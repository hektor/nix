{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:

let
  hmSopsAvailable = config ? sops && config.sops ? templates;
  osSopsAvailable = osConfig != null && osConfig ? sops && osConfig.sops ? templates;
  sopsAvailable = hmSopsAvailable || osSopsAvailable;

  sopsTemplates = if hmSopsAvailable then config.sops.templates else osConfig.sops.templates;
in
{
  warnings =
    lib.optional (!sopsAvailable && config.programs.taskwarrior.enable)
      "taskwarrior is enabled, but sops templates are not available. taskwarrior sync will not be configured.";

  home.packages = with pkgs; [
    libnotify
  ];

  home.file = {
    ".config/task/taskrc" = {
      force = true; # overwrite when present
      source = ../../dots/.config/task/taskrc;
    };
    ".config/task/taskrc.d/aliases".source = ../../dots/.config/task/taskrc.d/aliases;
    ".config/task/taskrc.d/colors".source = ../../dots/.config/task/taskrc.d/colors;
    ".config/task/taskrc.d/contexts".source = ../../dots/.config/task/taskrc.d/contexts;
    ".config/task/taskrc.d/reports".source = ../../dots/.config/task/taskrc.d/reports;
    ".config/task/taskrc.d/udas".source = ../../dots/.config/task/taskrc.d/udas;
    ".config/task/taskrc.d/urgency".source = ../../dots/.config/task/taskrc.d/urgency;
    ".local/share/task/hooks/on-exit.sync.py" = {
      source = ../../dots/.local/share/task/hooks/on-exit.sync.py;
    };
    ".local/share/task/scripts/sync-and-notify.sh" = {
      source = ../../dots/.local/share/task/scripts/sync-and-notify.sh;
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
    extraConfig = lib.optionalString sopsAvailable ''
      include ${sopsTemplates."taskrc.d/sync".path}
    '';
  };
}
