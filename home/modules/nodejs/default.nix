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
    fnm.enable = lib.mkEnableOption "fnm";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        cfg.package
        pnpm
        yarn
        biome
        tsx
      ]
      ++ lib.optional cfg.fnm.enable fnm;

    programs.bash.initExtra = lib.mkIf cfg.fnm.enable ''
      eval "$(fnm env --use-on-cd --shell bash)"
    '';

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
