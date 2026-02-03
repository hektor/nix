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
        "nix_signing_key_astyanax" = { };
        "nix_signing_key_andromache" = { };
        "opencode_api_key".owner = config.users.users.${cfg.username}.name;
        # TODO: using shared secrets for now, but would be better to to per-host secrets
        # To add per-host secrets:
        # "restic_password_${config.networking.hostName}" = { };
        # "restic_b2_account_id_${config.networking.hostName}" = { };
        # "restic_b2_account_key_${config.networking.hostName}" = { };
        "restic_password" = { };
        "b2_bucket_name" = { };
        "b2_account_id" = { };
        "b2_account_key" = { };
      };

      templates = {
        "taskrc.d/sync" = {
          owner = config.users.users.${cfg.username}.name;
          content = ''
            sync.server.url=${config.sops.placeholder."taskwarrior_sync_server_url"}
            sync.server.client_id=${config.sops.placeholder."taskwarrior_sync_server_client_id"}
            sync.encryption_secret=${config.sops.placeholder."taskwarrior_sync_encryption_secret"}
          '';
        };

        ".gitconfig.email" = {
          owner = config.users.users.${cfg.username}.name;
          path = "/home/${cfg.username}/.gitconfig.email";
          content = ''
            [user]
              email = ${config.sops.placeholder."email_personal"}
          '';
        };

        ".gitconfig.work.email" = {
          owner = config.users.users.${cfg.username}.name;
          path = "/home/${cfg.username}/.gitconfig.work.email";
          content = ''
            [user]
              email = ${config.sops.placeholder."email_work"}
          '';
        };

        "hcloud/cli.toml" = {
          owner = config.users.users.${cfg.username}.name;
          path = "/home/${cfg.username}/.config/hcloud/cli.toml";
          content = ''
            active_context = "server"

            [[contexts]]
              name = "server"
              token = "${config.sops.placeholder."hcloud"}"
          '';
        };

        "opencode/auth.json" = {
          owner = config.users.users.${cfg.username}.name;
          path = "/home/${cfg.username}/.local/share/opencode/auth.json";
          content = ''
            {
              "zai-coding-plan": {
                "type": "api",
                "key": "${config.sops.placeholder."opencode_api_key"}"
              }
            }
          '';
        };

        "restic/b2-env" = {
          content = ''
            B2_ACCOUNT_ID=${config.sops.placeholder."b2_account_id"}
            B2_ACCOUNT_KEY=${config.sops.placeholder."b2_account_key"}
          '';
        };
      };
    };
  };
}
