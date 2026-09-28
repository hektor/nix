{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.terminal;
in
{
  options.terminal.enable = lib.mkEnableOption "terminal";

  config = lib.mkIf cfg.enable {
    programs.bash.shellAliases = {
      icat = "kitty +kitten icat";
    };

    programs.kitty = {
      enable = true;
      package = config.nixgl.wrap pkgs.kitty;
      settings = {
        #: Fonts {{{
        font_family = "Iosevka Term SS08";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        font_size = 12.0;
        disable_ligatures = "never";
        # }}}

        #: Cursor {{{
        cursor_shape = "block";
        cursor_blink_interval = 0;
        #: }}}

        #: Scrollback {{{
        scrollback_lines = 8192;
        scrollbar = "scrolled";
        scrollback_pager_history_size = 1024;
        #: }}}

        #: Mouse {{{
        mouse_hide_wait = 0.0;
        paste_actions = "quote-urls-at-prompt";
        #: }}}

        #: Performance tuning {{{
        repaint_delay = 8;
        input_delay = 2;
        #: }}}

        #: Terminal bell {{{
        enable_audio_bell = true;
        window_alert_on_bell = true;
        #: }}}

        #: Window layout {{{
        remember_window_size = false;
        remember_window_position = false;
        enabled_layouts = "*";
        hide_window_decorations = true;
        #: }}}

        #: Advanced {{{
        notify_on_cmd_finish = "unfocused";
        #: }}}

        #: OS specific tweaks {{{
        linux_display_server = "auto";
        wayland_enable_ime = false;
        #: }}}

        kitty_mod = "ctrl+shift";
        allow_remote_control = "socket-only";
        listen_on = "unix:/tmp/kitty";
        shell_integration = "enabled";
      };

      #: Keyboard shortcuts {{{
      keybindings = {
        "kitty_mod+c" = "copy_to_clipboard";
        "kitty_mod+v" = "paste_from_clipboard";
        "cmd+v" = "";
        # map kitty_mod+o pass_selection_to_program
        # map kitty_mod+o pass_selection_to_program firefox
        # map kitty_mod+y new_window less @selection
        "kitty_mod+z" = "scroll_to_prompt -1";
        "kitty_mod+x" = "scroll_to_prompt 1";
        "kitty_mod+h" = "kitty_scrollback_nvim";
        # map f1 launch --stdin-source=@screen_scrollback --stdin-add-formatting --type=overlay less +G -R
        #::  For more details on piping screen and buffer contents to external
        #::  programs, see launch <https://sw.kovidgoyal.net/kitty/launch/>.
        # map kitty_mod+g show_last_command_output
        # map kitty_mod+enter launch --cwd=current
        # map cmd+enter
        # map ctrl+n launch --location=neighbor
        # map ctrl+f launch --location=first
        "kitty_mod+n" = "";
        "cmd+n" = "";
        "kitty_mod+w" = "";
        "shift+cmd+d" = "";
        "kitty_mod+]" = "";
        "kitty_mod+[" = "";
        "kitty_mod+f" = "";
        "kitty_mod+b" = "";
        "kitty_mod+`" = "";
        "cmd+r" = "";
        "kitty_mod+1" = "";
        "cmd+1" = "";
        "kitty_mod+2" = "";
        "cmd+2" = "";
        "kitty_mod+3" = "";
        "cmd+3" = "";
        "kitty_mod+4" = "";
        "cmd+4" = "";
        "kitty_mod+5" = "";
        "cmd+5" = "";
        "kitty_mod+6" = "";
        "cmd+6" = "";
        "kitty_mod+7" = "";
        "cmd+7" = "";
        "kitty_mod+8" = "";
        "cmd+8" = "";
        "kitty_mod+9" = "";
        "cmd+9" = "";
        "kitty_mod+0" = "";
        # map kitty_mod+c new_tab # FIXME: conflict with 'copy'
        "cmd+t" = "";
        "kitty_mod+q" = "";
        "cmd+w" = "";
        "kitty_mod+." = "";
        "kitty_mod+," = "";
        "kitty_mod+alt+t" = "";
        "shift+cmd+i" = "";
        "kitty_mod+f1" = "";
        "kitty_mod+f11" = "";
        "ctrl+cmd+f" = "";
        "kitty_mod+f10" = "";
        "opt+cmd+s" = "";
        "kitty_mod+u" = "kitten unicode_input";
        "ctrl+cmd+space" = "";
        "kitty_mod+/" = "kitty_shell window";
        "kitty_mod+f5" = "";
        "kitty_mod+r" = "load_config_file";

        "shift+cmd+/" = "";
        "cmd+h" = "";
        "opt+cmd+" = "";
        "cmd+m" = "";
        "cmd+q" = "";

        "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
      };
      #: }}}
      actionAliases.kitty_scrollback_nvim = "kitten ~/.local/share/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py";
      mouseBindings."ctrl+shift+right press" =
        "ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";
    };

    home.file.".local/share/kitty-scrollback.nvim".source = pkgs.vimPlugins.kitty-scrollback-nvim;
  };
}
