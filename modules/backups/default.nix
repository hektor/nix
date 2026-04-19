{
  lib,
  config,
  myUtils,
  ...
}:

let
  cfg = config.restic-backup;
  inherit (config.secrets) sopsDir;
  mkSopsSecrets = myUtils.mkSopsSecrets sopsDir;
  host = config.networking.hostName;
in
{
  options.restic-backup = {
    enable = lib.mkEnableOption "restic backups";

    passwordFile = lib.mkOption {
      type = lib.types.str;
      default = config.sops.secrets."restic/password".path;
    };

    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "/home" ];
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets = lib.mkMerge [
        (mkSopsSecrets "restic" [ "password" ] { })
        (mkSopsSecrets "backblaze-b2" [ "bucket-name" "account-id" "account-key" ] { })
      ];
      templates = {
        "restic/repo-${host}" = {
          content = "b2:${config.sops.placeholder."backblaze-b2/bucket-name"}:${host}";
        };
        "restic/b2-env-${host}" = {
          content = ''
            B2_ACCOUNT_ID=${config.sops.placeholder."backblaze-b2/account-id"}
            B2_ACCOUNT_KEY=${config.sops.placeholder."backblaze-b2/account-key"}
          '';
        };
      };
    };

    services.restic.backups.home = {
      repositoryFile = config.sops.templates."restic/repo-${host}".path;
      inherit (cfg) passwordFile paths;
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
      environmentFile = config.sops.templates."restic/b2-env-${host}".path;
    };
  };
}
