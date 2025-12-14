{ config, pkgs, ... }:

{
  programs.anki = {
    enable = true;
    addons = with pkgs.ankiAddons; [
      anki-connect
      puppy-reinforcement
      review-heatmap
    ];
    sync = {
      usernameFile = "${config.sops.secrets."anki_sync_user".path}";
      keyFile = "${config.sops.secrets."anki_sync_key".path}";
    };
  };
}
