{ lib, config, ... }:

let
  cfg = config.taskwarrior;
  inherit (config.secrets) owner;
in
{
  options.taskwarrior.enable = lib.mkEnableOption "taskwarrior";

  config = lib.mkIf cfg.enable {
    secrets.taskwarrior = [
      "sync-server-url"
      "sync-server-client-id"
      "sync-encryption-secret"
    ];

    sops.templates."taskrc.d/sync" = {
      inherit owner;
      content = ''
        sync.server.url=${config.sops.placeholder."taskwarrior/sync-server-url"}
        sync.server.client_id=${config.sops.placeholder."taskwarrior/sync-server-client-id"}
        sync.encryption_secret=${config.sops.placeholder."taskwarrior/sync-encryption-secret"}
      '';
    };
  };
}
