{
  config,
  lib,
  dotsPath,
  ...
}:

let
  cfg = config.shell.bash;
  inherit (config.home) homeDirectory;
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
      shellAliases =
        lib.optionalAttrs cfg.aliases.all (import ./bash-aliases.nix)
        // lib.optionalAttrs cfg.aliases.lang-js {
          js = "node";
          ts = "ts-node";
        };
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
        for f in ${homeDirectory}/.bashrc.d/*; do
          [ -f "$f" ] && source "$f"
        done
        ${lib.optionalString cfg.aliases.lang-js (builtins.readFile ./bash-js.bash)}
        ${cfg.extraInit}
      '';
    };

    home.sessionPath = lib.optional cfg.addBinToPath "${dotsPath}/.bin";
  };
}
