{
  programs.git.enable = true;
  home.file = {
    ".gitconfig".source = ../../dots/.gitconfig;
    ".gitconfig.work".source = ../../dots/.gitconfig.work;
    ".gitignore".source = ../../dots/.gitignore;
  };
}
