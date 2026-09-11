{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.git.gitlab;
in
{
  options.git.gitlab.enable = lib.mkEnableOption "Gitlab CLI";

  config = lib.mkIf (config.git.enable && cfg.enable) {
    home.packages = [ pkgs.glab ];
  };
}
