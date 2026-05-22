{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nodejs;
in
{
  options.nodejs = {
    enable = lib.mkEnableOption "Node.js";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nodejs_24;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
      pnpm
      yarn
      biome
      tsx
    ];
  };
}
