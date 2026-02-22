{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  config =
    lib.mkIf (config.browser.primary == "librewolf" || config.browser.secondary == "librewolf")
      {
        programs.librewolf = {
          enable = true;
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
