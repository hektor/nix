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
  imports = [ ./utils.nix ];

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
      default = true;
    };

    extraInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        for f in /home/${username}/.bashrc.d/*; do
          [ -f "$f" ] && source "$f"
        done

        ${lib.optionalString cfg.aliases.all "source /home/${username}/.bash_aliases/all"}
        ${lib.optionalString cfg.aliases.lang-js "source /home/${username}/.bash_aliases/lang-js"}

        ${lib.optionalString cfg.addBinToPath "export PATH=${dotsPath}/.bin:$PATH"}

        ${cfg.extraInit}
      '';
    };

    home.file = {
      ".inputrc".source = dotsPath + "/.inputrc";
      ".bashrc.d/prompt".source = dotsPath + "/.bashrc.d/prompt";
      ".bashrc.d/editor".source = dotsPath + "/.bashrc.d/editor";
    }
    // lib.optionalAttrs cfg.aliases.all {
      ".bash_aliases/all".source = dotsPath + "/.bash_aliases/all";
    }
    // lib.optionalAttrs cfg.aliases.lang-js {
      ".bash_aliases/lang-js".source = dotsPath + "/.bash_aliases/lang-js";
    };
  };
}
