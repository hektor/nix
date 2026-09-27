{ lib, config, ... }:

{
  options.readline.enable = lib.mkEnableOption "readline";

  config = lib.mkIf config.readline.enable {
    programs.readline = {
      enable = true;
      includeSystemConfig = true;
      variables = {
        editing-mode = "vi";
        keymap = "vi";
        show-mode-in-prompt = true;
        vi-ins-mode-string = ''"\1\e[1;32m\2■ \1\e[0m\2"'';
        vi-cmd-mode-string = ''"\1\e[1;31m\2■ \1\e[0m\2"'';

        show-all-if-ambiguous = true;
        show-all-if-unmodified = false;
        completion-ignore-case = true;
        completion-map-case = true;
        completion-display-width = 0;
        page-completions = false;
        completion-query-items = 128;
        visible-stats = true;
        skip-completed-text = true;
        mark-symlinked-directories = true;
        colored-completion-prefix = true;
      };
      extraConfig = ''
        $if mode=vi
          set keyseq-timeout 200
          set keymap vi-command
          "\e[A": history-search-backward
          "\e[B": history-search-forward
          j: history-search-forward
          k: history-search-backward
          set keymap vi-insert
          "jj": vi-movement-mode
          "\e[A": history-search-backward
          "\e[B": history-search-forward
          "\C-l": clear-screen
        $endif
      '';
    };
  };
}
