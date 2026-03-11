{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nodejs.package = lib.mkOption {
    type = lib.types.package;
    default = pkgs.nodejs_24;
  };

  config = {
    home.packages = with pkgs; [
      config.nodejs.package
      pnpm
      yarn
      biome
      tsx
    ];
  };
}
