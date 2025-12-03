{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/applications/terminal" = {
      exec = "kitty";
      exec-arg = "";
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-opacity = 100;
      picture-options = "zoom";
      picture-uri = "none";
      picture-uri-dark = "none";
      primary-color = "#555555";
      secondary-color = "#555555";
      show-desktop-icons = false;
    };

    # "org/gnome/desktop/input-sources" = {
    #   sources = [
    #     (mkTuple [
    #       "xkb"
    #       "us"
    #     ])
    #   ];
    #   xkb-options = [ "caps:none" ];
    # };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Shift><Super>Delete" ];
      cycle-group = [ ];
      cycle-group-backward = [ ];
      cycle-panels = [ ];
      cycle-panels-backward = [ ];
      cycle-windows = [ ];
      cycle-windows-backward = [ ];
      maximize = [ "<Super> " ];
      minimize = [ ];
      move-to-workspace-1 = [ "<Super><Shift>a" ];
      move-to-workspace-2 = [ "<Super><Shift>s" ];
      move-to-workspace-3 = [ "<Super><Shift>d" ];
      move-to-workspace-4 = [ "<Super><Shift>f" ];
      move-to-workspace-5 = [ "<Super><Shift>g" ];
      move-to-workspace-last = [ ];
      move-to-workspace-left = [ "<Super><Shift>h" ];
      move-to-workspace-right = [ "<Super><Shift>l" ];
      panel-run-dialog = [ ];
      switch-applications = [ "<Super>j" ];
      switch-applications-backward = [ "<Super>k" ];
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-panels = [ ];
      switch-panels-backward = [ ];
      switch-to-workspace-1 = [ "<Super>a" ];
      switch-to-workspace-2 = [ "<Super>s" ];
      switch-to-workspace-3 = [ "<Super>d" ];
      switch-to-workspace-4 = [ "<Super>f" ];
      switch-to-workspace-5 = [ "<Super>g" ];
      switch-to-workspace-last = [ ];
      switch-to-workspace-left = [ "<Super>h" ];
      switch-to-workspace-right = [ "<Super>l" ];
      switch-windows = [ ];
      switch-windows-backward = [ ];
      toggle-maximized = [ "<Super>space" ];
      unmaximize = [ ];
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 5;
      workspace-names = [
        "sh"
        "www"
        "dev"
        "info"
        "etc"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "Print";
      command = "flameshot gui";
      name = "flameshot";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>Return";
      command = "kitty";
      name = "Kitty";
    };

    "org/gnome/shell/keybindings" = {
      screenshot = [ "Print" ];
      toggle-application-view = [ "<Super>p" ];
      toggle-quick-settings = [ ];
    };
  };
}
