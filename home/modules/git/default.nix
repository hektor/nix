{
  config,
  lib,
  dotsPath,
  ...
}:

{
  options.git = {
    enable = lib.mkEnableOption "git";

    gitea = {
      enable = lib.mkEnableOption "Gitea CLI";
    };
    github = {
      enable = lib.mkEnableOption "Github CLI";
    };
    gitlab = {
      enable = lib.mkEnableOption "Gitlab CLI";
    };
  };

  imports = [
    ./gitea.nix
    ./github.nix
    ./gitlab.nix
  ];

  config = lib.mkIf config.git.enable {
    assertions = [
      {
        assertion = config.nvim.enable;
        message = "git module requires 'nvim' module (`nvimdiff`)";
      }
    ];
    programs.git.enable = true;
    home.file = {
      ".gitconfig".source = dotsPath + "/.gitconfig";
      ".gitconfig.work".source = dotsPath + "/.gitconfig.work";
      ".gitignore".source = dotsPath + "/.gitignore";
    };
  };
}
