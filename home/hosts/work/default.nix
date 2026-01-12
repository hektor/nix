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
    ../../modules/keepassxc.nix
    ../../modules/browser
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  browser.primary = "firefox";
  browser.secondary = "chromium";

  programs = {
    gh.enable = true;
    kubecolor.enable = true;
  };

  home.packages = import ./packages.nix {
    inherit inputs;
    inherit config;
    inherit pkgs;
  };
}
