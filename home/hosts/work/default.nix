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

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  programs = {
    # editorconfig.enable = true;
    firefox = import ../../modules/firefox.nix {
      inherit inputs;
      inherit pkgs;
      inherit config;
    };
    gh.enable = true;
    keepassxc = import ../../modules/keepassxc.nix;
    kubecolor.enable = true;
  };

  home.packages = import ./packages.nix {
    inherit inputs;
    inherit config;
    inherit pkgs;
  };
}
