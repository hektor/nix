{
  lib,
  inputs,
  config,
  ...
}:

let
  cfg = config.secrets;
in
{
  options = {
    secrets.username = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = {
    sops = {
      validateSopsFiles = false;
      defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/${cfg.username}/.config/sops/age/keys.txt";

      secrets = {
        "taskwarrior_sync_server_url".owner = config.users.users.${cfg.username}.name;
        "taskwarrior_sync_server_client_id".owner = config.users.users.${cfg.username}.name;
        "taskwarrior_sync_encryption_secret".owner = config.users.users.${cfg.username}.name;
      };

      templates."taskrc.d/sync" = {
        owner = config.users.users.${cfg.username}.name;
        content = ''
          sync.server.url=${config.sops.placeholder."taskwarrior_sync_server_url"}
          sync.server.client_id=${config.sops.placeholder."taskwarrior_sync_server_client_id"}
          sync.encryption_secret=${config.sops.placeholder."taskwarrior_sync_encryption_secret"}
        '';
      };
    };
  };
}
