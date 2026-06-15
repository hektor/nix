{ lib, config, ... }:

let
  cfg = config.anki;
in
{
  options.anki.enable = lib.mkEnableOption "anki";

  config = lib.mkIf cfg.enable {
    secrets.user.anki = [
      "sync-user"
      "sync-key"
    ];
  };
}
