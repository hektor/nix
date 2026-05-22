{ lib, config, ... }:

let
  cfg = config.localization;
in
{
  options.localization.enable = lib.mkEnableOption "localization";

  config = lib.mkIf cfg.enable {
    time.timeZone = config.host.timezone;
    i18n.defaultLocale = config.host.locale;
  };
}
