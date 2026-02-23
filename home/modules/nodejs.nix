{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nodejs = {
    enable = lib.mkEnableOption "nodejs (and related packages)";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nodejs_24;
    };
  };

  config = lib.mkIf config.nodejs.enable {
    home.packages = with pkgs; [
      config.nodejs.package
      pnpm
      yarn
      biome
      tsx
    ];
  };
}
