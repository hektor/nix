{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.swayidle;
in
{
  options.swayidle = {
    enable = lib.mkEnableOption "swayidle";
    timeout = lib.mkOption {
      type = lib.types.ints.positive;
      default = 900;
    };
  };

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          inherit (cfg) timeout;
          command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        }
      ];
    };
  };
}
