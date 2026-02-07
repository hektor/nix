{
  config,
  lib,
  pkgs,
  dotsPath,
  ...
}:

{
  options = {
    github.enable = lib.mkEnableOption "Github CLI";
    gitlab.enable = lib.mkEnableOption "Gitlab CLI";
  };

  config = {
    programs.git.enable = true;
    home.file = {
      ".gitconfig".source = dotsPath + "/.gitconfig";
      ".gitconfig.work".source = dotsPath + "/.gitconfig.work";
      ".gitignore".source = dotsPath + "/.gitignore";
    };

    programs.gh.enable = config.github.enable;
    home.packages = lib.optionals config.gitlab.enable [ pkgs.glab ];
  };
}
