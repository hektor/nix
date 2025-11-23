{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    python314
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
      # sync = {
      #   server.url = "${builtins.readFile config.sops.secrets."taskwarrior_sync_server_url".path}";
      #   server.client_id = "${builtins.readFile
      #     config.sops.secrets."taskwarrior_sync_server_client_id".path
      #   }";
      #   encryption_secret = "${builtins.readFile
      #     config.sops.secrets."taskwarrior_sync_encryption_secret".path
      #   }";
      # };
      recurrence = "off"; # TODO: enable only on andromache
    };
    extraConfig = "include ${config.sops.templates."taskrc.d/sync".path}";
  };
}
