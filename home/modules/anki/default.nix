{
  config,
  lib,
  pkgs,
  myUtils,
  osConfig ? null,
  inputs ? null,
  ...
}:

let
  cfg = config.anki;
  sops = myUtils.sopsAvailability config osConfig;
  standalone = osConfig == null;
in
{
  options.anki.enable = lib.mkEnableOption "Anki";

  config = lib.mkIf cfg.enable (
    lib.optionalAttrs standalone {
      sops.secrets = myUtils.mkSopsSecrets "${toString inputs.nix-secrets}/secrets" null {
        anki = [
          "sync-user"
          "sync-key"
        ];
      };
    }
    // {
      warnings = lib.optional (
        !sops.available
      ) "anki is enabled but sops secrets are not available. anki sync will not be configured.";

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
        profiles."User 1".sync = lib.mkIf sops.available {
          usernameFile = "${sops.secrets."anki/sync-user".path}";
          keyFile = "${sops.secrets."anki/sync-key".path}";
        };
      };
    }
  );
}
