{ lib, config, ... }:

let
  cfg = config.anki;
in
{
  options.anki.enable = lib.mkEnableOption "anki";

  config = lib.mkIf cfg.enable {
    secrets.groups.anki = [
      "sync-user"
      "sync-key"
    ];
  };
}
