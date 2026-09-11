{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.git.gitea;
in
{
  options.git.gitea.enable = lib.mkEnableOption "Gitea CLI";

  config = lib.mkIf (config.git.enable && cfg.enable) {
    home.packages = [ pkgs.tea ];
  };
}
