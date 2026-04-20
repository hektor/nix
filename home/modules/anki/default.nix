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
  sops = myUtils.sopsAvailability config osConfig;
  standalone = osConfig == null;
in
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
    !sops.available && config.programs.anki.enable
  ) "anki is enabled but sops secrets are not available. anki sync will not be configured.";

  programs.anki = {
    enable = true;
    package = config.nixgl.wrap pkgs.anki;
    addons = with pkgs.ankiAddons; [
      anki-connect
      puppy-reinforcement
      review-heatmap
    ];
    profiles."User 1".sync = lib.mkIf sops.available {
      usernameFile = "${sops.secrets."anki/sync-user".path}";
      keyFile = "${sops.secrets."anki/sync-key".path}";
    };
  };
}
