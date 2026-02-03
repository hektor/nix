{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  username = "h";
in
{
  imports = [
    ../../modules/ai-tools.nix
    ../../modules/cloud
    ../../modules/comms
    ../../modules/desktop/niri
    ../../modules/direnv
    ../../modules/3d
    ../../modules/git
    ../../modules/k8s/k9s.nix
    ../../modules/kitty.nix
    ../../modules/music
    ../../modules/nvim.nix
    ../../modules/ssh.nix
    ../../modules/taskwarrior.nix
    ../../modules/keepassxc.nix
    ../../modules/anki.nix
    ../../modules/photography
    ../../modules/browser
    ../../modules/shell
  ];

  home = {
    stateVersion = "25.05";
    inherit username;
    homeDirectory = "/home/${username}";
  };

  xdg.userDirs.createDirectories = false;
  xdg.userDirs.download = "${config.home.homeDirectory}/dl";

  browser.primary = "librewolf";
  cloud.hetzner.enable = true;
  comms.signal.enable = true;
  github.enable = true;

  shell.bash = {
    enable = true;
    aliases.lang-js = true;
  };

  programs = {
    home-manager.enable = true;
    taskwarrior.config.recurrence = lib.mkForce "on";
  };

  home.packages = import ../packages.nix { inherit pkgs; };
}
