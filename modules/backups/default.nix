{
  lib,
  config,
  ...
}:

let
  cfg = config.restic-backup;
  inherit (config.secrets) sopsDir;
in
{
  options = {
    restic-backup = {
      repository = lib.mkOption {
        type = lib.types.str;
        default = "b2:${config.sops.placeholder.b2-bucket-name}:${config.networking.hostName}";
      };

      passwordFile = lib.mkOption {
        type = lib.types.str;
        default = config.sops.secrets.restic-password.path;
      };

      paths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "/home" ];
      };
    };
  };

  config = {
    sops = {
      secrets = {
        restic-password = {
          sopsFile = "${sopsDir}/restic-password";
        };
        b2-bucket-name = {
          sopsFile = "${sopsDir}/b2-bucket-name";
        };
        b2-account-id = {
          sopsFile = "${sopsDir}/b2-account-id";
        };
        b2-account-key = {
          sopsFile = "${sopsDir}/b2-account-key";
        };
      };
      templates = {
        "restic/repo-${config.networking.hostName}" = {
          content = "b2:${config.sops.placeholder.b2-bucket-name}:${config.networking.hostName}";
        };
        "restic/b2-env-${config.networking.hostName}" = {
          content = ''
            B2_ACCOUNT_ID=${config.sops.placeholder.b2-account-id}
            B2_ACCOUNT_KEY=${config.sops.placeholder.b2-account-key}
          '';
        };
      };
    };

    services.restic.backups.home = {
      repositoryFile = config.sops.templates."restic/repo-${config.networking.hostName}".path;
      inherit (cfg) passwordFile;
      inherit (cfg) paths;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      initialize = true;
      extraBackupArgs = [ "--one-file-system" ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 1"
      ];
      environmentFile = config.sops.templates."restic/b2-env-${config.networking.hostName}".path;
    };
  };
}
