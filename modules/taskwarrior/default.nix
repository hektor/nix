{ config, myUtils, ... }:

let
  inherit (config.secrets) sopsDir;
  inherit (config.host) username;
  owner = config.users.users.${username}.name;
in
{
  config.sops = {
    secrets = myUtils.mkSopsSecrets sopsDir "taskwarrior" [
      "sync-server-url"
      "sync-server-client-id"
      "sync-encryption-secret"
    ] { inherit owner; };

    templates."taskrc.d/sync" = {
      inherit owner;
      content = ''
        sync.server.url=${config.sops.placeholder."taskwarrior/sync-server-url"}
        sync.server.client_id=${config.sops.placeholder."taskwarrior/sync-server-client-id"}
        sync.encryption_secret=${config.sops.placeholder."taskwarrior/sync-encryption-secret"}
      '';
    };
  };
}
