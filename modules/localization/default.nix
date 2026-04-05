{ config, ... }:

{
  time.timeZone = config.host.timezone;
  i18n.defaultLocale = config.host.locale;
}
