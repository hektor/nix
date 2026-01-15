{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:

let
  hmSopsAvailable = config ? sops && config.sops ? secrets;
  osSopsAvailable = osConfig != null && osConfig ? sops && osConfig.sops ? secrets;
  sopsAvailable = hmSopsAvailable || osSopsAvailable;

  sopsSecrets = if hmSopsAvailable then config.sops.secrets else osConfig.sops.secrets;
in
{
  warnings = lib.optional (
    !sopsAvailable && config.programs.anki.enable
  ) "anki is enabled but sops secrets are not available. anki sync will not be configured.";

  programs.anki = {
    enable = true;
    addons = with pkgs.ankiAddons; [
      anki-connect
      puppy-reinforcement
      review-heatmap
    ];
    sync = lib.mkIf sopsAvailable {
      usernameFile = "${sopsSecrets."anki_sync_user".path}";
      keyFile = "${sopsSecrets."anki_sync_key".path}";
    };
  };
}
