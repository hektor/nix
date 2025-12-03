{ config, lib, ... }:

let
  cfg = config.docker;
in
{
  options.docker = {
    rootless = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
  config = lib.mkMerge [
    {
      warnings = lib.flatten [
        (lib.optional (
          cfg.rootless && cfg.user != null
        ) "'virtualisation.docker.user' is ignored when rootless mode is enabled")
        (lib.optional (
          !cfg.rootless && cfg.user == null
        ) "'virtualisation.docker.user' is not set (no user is added to the docker group)")
      ];
    }
    (lib.mkIf cfg.rootless {
      virtualisation.docker = {
        enable = false;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    })
    (lib.mkIf (!cfg.rootless && cfg.user != null) {
      virtualisation.docker = {
        enable = true;
      };
      users.users.${cfg.user}.extraGroups = [ "docker" ];
    })
  ];
}
