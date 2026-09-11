{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.git.enable && config.git.gitea.enable) {
    home.packages = with pkgs; [ tea ];
  };
}
