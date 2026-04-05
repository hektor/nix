{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../modules
    ../../modules/3d
    ../../modules/ai-tools
    ../../modules/anki
    ../../modules/audio
    ../../modules/browser
    ../../modules/cloud
    ../../modules/comms
    ../../modules/desktop/niri
    ../../modules/devenv
    ../../modules/direnv
    ../../modules/git
    ../../modules/k8s/k9s.nix
    ../../modules/keepassxc
    ../../modules/music
    ../../modules/nvim
    ../../modules/pandoc
    ../../modules/photography
    ../../modules/shell
    ../../modules/ssh
    ../../modules/taskwarrior
    ../../modules/terminal
    ../../modules/torrenting
  ];

  home = {
    stateVersion = "25.05";
    inherit (config.host) username;
    homeDirectory = "/home/${config.host.username}";
  };

  xdg.userDirs.createDirectories = false;
  xdg.userDirs.download = "${config.home.homeDirectory}/dl";

  modules."3d" = {
    printing.enable = true;
    modeling.enable = true;
  };
  ai-tools.opencode.enable = true;
  browser.primary = "librewolf";
  cloud.hetzner.enable = true;
  comms.signal.enable = true;
  git.github.enable = true;
  shell.bash.aliases.lang-js = true;
  shell.bash.addBinToPath = true;
  torrenting.enable = true;

  programs = {
    home-manager.enable = true;
    taskwarrior.config.recurrence = lib.mkForce "on";
  };

  home.packages = import ../packages.nix { inherit pkgs; };
}
