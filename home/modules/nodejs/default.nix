{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nodejs;
  email = "contact@hektormisplon.xyz";
in
{
  options.nodejs = {
    enable = lib.mkEnableOption "Node.js";
    package = lib.mkPackageOption pkgs "nodejs_24" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
      pnpm
      yarn
      biome
      tsx
    ];

    programs.npm = {
      inherit (cfg) enable package;
      settings = {
        prefix = "${config.xdg.dataHome}/npm";
        cache = "${config.xdg.cacheHome}/npm";
        init-module = "${config.xdg.configHome}/npm/config/npm-init.js";
        init-author-name = "Hektor Misplon";
        init-author-email = email;
        init-license = "MIT";
      };
    };
  };
}
