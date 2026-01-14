{ lib, ... }:

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

  imports = [
    ./firefox.nix
    ./librewolf.nix
    ./chromium.nix
  ];
}
