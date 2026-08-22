{
  config,
  lib,
  dotsPath,
  ...
}:

let
  cfg = config.shell.bash;
  inherit (config.home) username;
in
{
  options.shell.bash = {
    aliases = {
      all = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      lang-js = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };

    addBinToPath = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    extraInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf config.shell.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      historySize = 999999;
      historyFileSize = -1; # unlimited
      historyControl = [
        "ignoreboth"
        "erasedups"
      ];
      # omit commands from history (e.g. those prepended with space)
      historyIgnore = [
        " *"
        "clear"
        "l"
        "ls"
        "cd"
      ];

      initExtra = ''
        for f in /home/${username}/.bashrc.d/*; do
          [ -f "$f" ] && source "$f"
        done

        ${lib.optionalString cfg.aliases.all "source /home/${username}/.bash_aliases/all"}
        ${lib.optionalString cfg.aliases.lang-js "source /home/${username}/.bash_aliases/lang-js"}

        ${cfg.extraInit}
      '';
    };

    home.file = {
      ".inputrc".source = dotsPath + "/.inputrc";
      ".bashrc.d/prompt".source = dotsPath + "/.bashrc.d/prompt";
    }
    // lib.optionalAttrs cfg.aliases.all {
      ".bash_aliases/all".source = dotsPath + "/.bash_aliases/all";
    }
    // lib.optionalAttrs cfg.aliases.lang-js {
      ".bash_aliases/lang-js".source = dotsPath + "/.bash_aliases/lang-js";
    };
    home.sessionPath = lib.optional cfg.addBinToPath "${dotsPath}/.bin";
  };
}
