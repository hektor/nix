{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.git.enable && config.git.gitlab.enable) {
    home.packages = with pkgs; [ glab ];
  };
}
