{ dotsPath, ... }:

{
  programs.git.enable = true;
  home.file = {
    ".gitconfig".source = dotsPath + "/.gitconfig";
    ".gitconfig.work".source = dotsPath + "/.gitconfig.work";
    ".gitignore".source = dotsPath + "/.gitignore";
  };
}
