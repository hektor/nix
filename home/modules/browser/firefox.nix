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
      configPath = ".mozilla/firefox";
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
