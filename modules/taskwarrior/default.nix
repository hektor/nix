{ config, ... }:

let
  inherit (config.secrets) owner;
in
{
  config = {
    secrets.groups.taskwarrior = [
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
