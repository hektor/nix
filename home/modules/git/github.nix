{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf (config.git.enable && config.git.github.enable) {
    programs.gh.enable = true;
  };
}
