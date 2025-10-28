{
  pkgs,
  config,
  inputs,
  ...
}:

{
  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  home.username = "hektor";
  home.homeDirectory = "/home/hektor";
  home.stateVersion = "25.05";

  programs.anki = import ../../modules/anki.nix;
  programs.firefox = import ../../modules/firefox.nix {
    inherit inputs;
    inherit pkgs;
  };

  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  home.packages = import ./packages.nix {
    inherit pkgs;
    inherit config;
  };
}
