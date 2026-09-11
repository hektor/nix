{
  config,
  lib,
  dotsPath,
  ...
}:

{
  imports = [
    ./gitea.nix
    ./github.nix
    ./gitlab.nix
  ];

  options.git.enable = lib.mkEnableOption "git";

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
