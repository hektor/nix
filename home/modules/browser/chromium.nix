{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.browser.primary == "chromium" || config.browser.secondary == "chromium") {
    home.packages = [ pkgs.chromium ];
  };
}
