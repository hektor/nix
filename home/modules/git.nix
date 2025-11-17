{
  programs.git.enable = true;
  home.file = {
    ".gitconfig".source = ../../dots/.gitconfig;
    ".gitignore".source = ../../dots/.gitignore;
  };
}
