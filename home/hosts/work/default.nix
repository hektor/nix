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
    ../../modules/dconf.nix # TODO: Only enable when on Gnome?
  ];

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  sops = {
    defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets."test" = { };
  };

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
    git = import ../../modules/git.nix;
    keepassxc = import ../../modules/keepassxc.nix;
  };
  home.packages = import ./packages.nix {
    inherit pkgs;
    inherit config;
  };
}
