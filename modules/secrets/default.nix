{
  lib,
  inputs,
  config,
  ...
}:

let
  cfg = config.secrets;
  inherit (cfg) sopsDir;
  owner = config.users.users.${cfg.username}.name;

  mkSecret = name: {
    ${name} = {
      sopsFile = "${sopsDir}/${name}";
      inherit owner;
    };
  };
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options = {
    secrets = {
      username = lib.mkOption {
        type = lib.types.str;
      };

      sopsDir = lib.mkOption {
        type = lib.types.str;
        default = "${toString inputs.nix-secrets}/secrets";
      };

      nixSigningKey = {
        enable = lib.mkEnableOption "nix signing key configuration";
        name = lib.mkOption {
          type = lib.types.str;
          default = "${config.host.name}-nix-signing-key";
        };
      };
    };
  };

  config = {
    sops = {
      age.keyFile = "/home/${cfg.username}/.config/sops/age/keys.txt";

      secrets = lib.mkMerge [
        (mkSecret "taskwarrior-sync-server-url")
        (mkSecret "taskwarrior-sync-server-client-id")
        (mkSecret "taskwarrior-sync-encryption-secret")
        (mkSecret "anki-sync-user")
        (mkSecret "anki-sync-key")
        (mkSecret "email-personal")
        (mkSecret "email-work")
        (mkSecret "opencode-api-key")
        (lib.mkIf cfg.nixSigningKey.enable (mkSecret cfg.nixSigningKey.name))
      ];

      templates = {
        "taskrc.d/sync" = {
          inherit owner;
          content = ''
            sync.server.url=${config.sops.placeholder.taskwarrior-sync-server-url}
            sync.server.client_id=${config.sops.placeholder.taskwarrior-sync-server-client-id}
            sync.encryption_secret=${config.sops.placeholder.taskwarrior-sync-encryption-secret}
          '';
        };

        ".gitconfig.email" = {
          inherit owner;
          path = "/home/${cfg.username}/.gitconfig.email";
          content = ''
            [user]
              email = ${config.sops.placeholder.email-personal}
          '';
        };
        ".gitconfig.work.email" = {
          inherit owner;
          path = "/home/${cfg.username}/.gitconfig.work.email";
          content = ''
            [user]
              email = ${config.sops.placeholder.email-work}
          '';
        };

        "opencode/auth.json" = {
          inherit owner;
          path = "/home/${cfg.username}/.local/share/opencode/auth.json";
          content = ''
            {
              "zai-coding-plan": {
                "type": "api",
                "key": "${config.sops.placeholder.opencode-api-key}"
              }
            }
          '';
        };
      };
    };

    nix.settings.secret-key-files = lib.mkIf cfg.nixSigningKey.enable [
      config.sops.secrets.${cfg.nixSigningKey.name}.path
    ];
  };
}
