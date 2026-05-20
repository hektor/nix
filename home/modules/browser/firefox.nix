{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.browser.primary == "firefox" || config.browser.secondary == "firefox") {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    }
    // (import ./firefox-base.nix {
      inherit
        config
        inputs
        lib
        pkgs
        ;
    });
  };
}
