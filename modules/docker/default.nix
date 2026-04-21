{ config, lib, ... }:

let
  cfg = config.docker;
  inherit (config.host) username;
in
{
  options.docker = {
    enable = lib.mkEnableOption "docker";
    rootless = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.rootless {
      virtualisation.docker = {
        enable = false;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    })
    (lib.mkIf (cfg.enable && !cfg.rootless) {
      virtualisation.docker.enable = true;
      users.users.${username}.extraGroups = [ "docker" ];
    })
  ];
}
