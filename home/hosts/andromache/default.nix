{
  lib,
  config,
  pkgs,
  ...
}:

let
  username = "h";
in
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
  ];

  home = {
    stateVersion = "25.05";
    inherit username;
    homeDirectory = "/home/${username}";
  };

  xdg.userDirs.createDirectories = false;
  xdg.userDirs.download = "${config.home.homeDirectory}/dl";

  ai-tools.opencode.enable = true;
  browser.primary = "librewolf";
  cloud.hetzner.enable = true;
  comms.signal.enable = true;
  github.enable = true;
  shell.bash.aliases.lang-js = true;

  programs = {
    home-manager.enable = true;
    taskwarrior.config.recurrence = lib.mkForce "on";
  };

  home.packages = import ../packages.nix { inherit pkgs; };
}
