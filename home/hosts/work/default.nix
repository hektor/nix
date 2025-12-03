{
  inputs,
  config,
  pkgs,
  ...
}:

let
  username = "hektor";
in
{
  imports = [
    ../../modules/dconf.nix
    ../../modules/git.nix
    ../../modules/k9s.nix
  ];

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  programs = {
    anki = import ../../modules/anki.nix;
    firefox = import ../../modules/firefox.nix {
      inherit inputs;
      inherit pkgs;
      inherit config;
    };
    keepassxc = import ../../modules/keepassxc.nix;
  };
  home.packages = import ./packages.nix {
    inherit pkgs;
    inherit config;
  };
}
