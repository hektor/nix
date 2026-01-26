{
  config,
  lib,
  pkgs,
  dotsPath,
  ...
}:
let
  cfg = config.shell.bash;
  inherit (config.home) username;
in
{
  options.shell.bash = {
    enable = lib.mkEnableOption "bash configuration";

    aliases = {
      all = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable common aliases";
      };
      lang-js = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable JavaScript/Node.js aliases";
      };
    };

    addBinToPath = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Add dots .bin directory to PATH";
    };

    extraInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional bash initialization";
    };
  };

  config = lib.mkIf cfg.enable {
    shell-utils.enable = lib.mkDefault true;

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
