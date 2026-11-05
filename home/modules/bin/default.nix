{
  config,
  lib,
  pkgs,
  ...
}:

let
  script =
    name: args:
    pkgs.writeShellApplication (
      {
        inherit name;
        text = builtins.readFile ./scripts/${name};
      }
      // args
    );
  pythonScript =
    name: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = ''exec ${lib.getExe pkgs.python3} ${pkgs.writeTextDir name (builtins.readFile ./scripts/${name})}/${name} "$@"'';
    };
  ssh-hosts = script "ssh-hosts" {
    runtimeInputs = with pkgs; [
      gnugrep
      gawk
    ];
  };
  scripts = with pkgs; {
    bak.runtimeInputs = [ coreutils ];
    notify.runtimeInputs = [ libnotify ];
    pdftitle.runtimeInputs = [
      poppler-utils
      gawk
      coreutils
    ];
    fzf-book.runtimeInputs = [
      findutils
      fzf
      coreutils
    ];
    fzf-ssh.runtimeInputs = [
      ssh-hosts
      fzf
    ];
    save-ssh-host = {
      runtimeInputs = [
        ssh-hosts
        fzf
      ];
      excludeShellChecks = [ "SC2029" ];
    };
    fzf-fontnames.runtimeInputs = [
      fontconfig
      fzf
      gawk
      coreutils
    ];
    get-anki-decks.runtimeInputs = [
      curl
      jq
    ];
    get-anki-reviews-status = {
      runtimeInputs = [ coreutils ];
      runtimeEnv.ANKI_REVIEWS = config.anki.reviewsCache;
    };
  };
  pythonScripts = with pkgs; {
    pomo = [ libnotify ];
    taskdeps = [ ];
  };
in
{
  options.bin.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.bin.enable {
    home.packages = [
      ssh-hosts
    ]
    ++ lib.mapAttrsToList script scripts
    ++ lib.mapAttrsToList pythonScript pythonScripts;
  };
}
