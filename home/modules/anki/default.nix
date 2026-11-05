{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.anki;
  syncReady = config.secrets.path ? "anki/sync-user" && config.secrets.path ? "anki/sync-key";
in
{
  options.anki.enable = lib.mkEnableOption "Anki";
  options.anki.reviewsCache = lib.mkOption {
    default = "/tmp/anki-reviews";
    type = lib.types.str;
  };

  config = lib.mkIf cfg.enable {
    secrets.files.anki = [
      "sync-user"
      "sync-key"
    ];

    warnings = lib.optional (
      !syncReady
    ) "anki is enabled but its secrets are unavailable. anki sync will not be configured.";

    programs.anki = {
      enable = true;
      package = config.nixgl.wrap pkgs.anki;
      addons = with pkgs.ankiAddons; [
        (anki-connect.withConfig {
          # https://git.sr.ht/~foosoft/anki-connect/tree/master/item/plugin/config.json
          config = {
            apiKey = null;
            apiLogPath = null;
            webBindAddress = "127.0.0.1";
            webBindPort = 8765;
            webCorsOriginList = [ "http://localhost" ];
            ignoreOriginList = [ ];
          };
        })
        puppy-reinforcement
        review-heatmap
      ];
      profiles."User 1".sync = lib.mkIf syncReady {
        usernameFile = config.secrets.path."anki/sync-user";
        keyFile = config.secrets.path."anki/sync-key";
      };
    };

    # allow Anki to write prefs
    home.file."${config.xdg.dataHome}/Anki2/prefs21.db".enable = lib.mkForce false;
  };
}
