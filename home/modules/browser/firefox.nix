{ config, lib, inputs, pkgs, ... }:

{
  config = lib.mkIf (config.browser.primary == "firefox" || config.browser.secondary == "firefox") {
    programs.firefox = {
      enable = true;
    }
    // (import ./firefox-base.nix { inherit inputs pkgs; });
  };
}
