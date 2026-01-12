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
      description = "Primary web browser";
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
      description = "Optional secondary web browser";
    };
  };

  imports = [
    ./firefox.nix
    ./librewolf.nix
    ./chromium.nix
  ];
}
