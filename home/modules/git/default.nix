{
  config,
  lib,
  pkgs,
  dotsPath,
  ...
}:

{
  options.git = {
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

    programs.gh.enable = config.git.github.enable;
    home.packages = lib.optionals config.git.gitlab.enable [ pkgs.glab ];
  };
}
