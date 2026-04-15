{ config, lib, ... }:

{
  options.browser = {
    primary = lib.mkOption {
      type = lib.types.enum [
        "firefox"
        "chromium"
        "librewolf"
      ];
      default = "firefox";
    };

    secondary = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "firefox"
          "chromium"
          "librewolf"
        ]
      );
      default = null;
    };
  };

  config.home.sessionVariables.BROWSER = config.browser.primary;

  imports = [
    ./firefox.nix
    ./librewolf.nix
    ./chromium.nix
  ];
}
