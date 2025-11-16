{
  pkgs,
  config,
  inputs,
  ...
}:

{

  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/hektor/.config/sops/age/keys.txt";

    secrets."test" = { };
  };

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
    inherit config;
  };
  programs.git = import ../../modules/git.nix;
  programs.keepassxc = import ../../modules/keepassxc.nix;
  home.packages = import ./packages.nix {
    inherit pkgs;
    inherit config;
  };
}
