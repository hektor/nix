{
  config,
  lib,
  ...
}:

let
  cfg = config.mako;
in
{
  options.mako.enable = lib.mkEnableOption "mako";

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 10000;
        "urgency=critical".default-timeout = 0;
      };
    };
  };
}
