{
  config,
  lib,
  ...
}:

let
  cfg = config.git.github;
in
{
  options.git.github.enable = lib.mkEnableOption "Github CLI";

  config = lib.mkIf (config.git.enable && cfg.enable) {
    programs.gh.enable = true;
  };
}
