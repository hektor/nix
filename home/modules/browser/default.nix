{
  config,
  lib,
  ...
}:

{
  imports = [
    ./firefox.nix
    ./librewolf.nix
    ./chromium.nix
  ];

  options.browser = {
    enable = lib.mkEnableOption "browser";

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

  config = lib.mkIf config.browser.enable {
    home.sessionVariables.BROWSER = config.browser.primary;
  };
}
