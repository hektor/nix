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
      defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/${cfg.username}/.config/sops/age/keys.txt";

      secrets = {
        "taskwarrior_sync_server_url".owner = config.users.users.${cfg.username}.name;
        "taskwarrior_sync_server_client_id".owner = config.users.users.${cfg.username}.name;
        "taskwarrior_sync_encryption_secret".owner = config.users.users.${cfg.username}.name;
        "email_personal".owner = config.users.users.${cfg.username}.name;
        "email_work".owner = config.users.users.${cfg.username}.name;
        "anki_sync_user".owner = config.users.users.${cfg.username}.name;
        "anki_sync_key".owner = config.users.users.${cfg.username}.name;
        "hcloud".owner = config.users.users.${cfg.username}.name;
      };

      templates."taskrc.d/sync" = {
        owner = config.users.users.${cfg.username}.name;
        content = ''
          sync.server.url=${config.sops.placeholder."taskwarrior_sync_server_url"}
          sync.server.client_id=${config.sops.placeholder."taskwarrior_sync_server_client_id"}
          sync.encryption_secret=${config.sops.placeholder."taskwarrior_sync_encryption_secret"}
        '';
      };

      templates.".gitconfig.email" = {
        owner = config.users.users.${cfg.username}.name;
        path = "/home/${cfg.username}/.gitconfig.email";
        content = ''
          [user]
            email = ${config.sops.placeholder."email_personal"}
        '';
      };

      templates.".gitconfig.work.email" = {
        owner = config.users.users.${cfg.username}.name;
        path = "/home/${cfg.username}/.gitconfig.work.email";
        content = ''
          [user]
            email = ${config.sops.placeholder."email_work"}
        '';
      };

      templates."hcloud/cli.toml" = {
        owner = config.users.users.${cfg.username}.name;
        path = "/home/${cfg.username}/.config/hcloud/cli.toml";
        content = ''
          active_context = "server"

          [[contexts]]
            name = "server"
            token = "${config.sops.placeholder."hcloud"}"
        '';
      };
    };
  };
}
