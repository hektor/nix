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
    ../../modules/desktop/niri

    ../../modules/3d
    ../../modules/git.nix
    # ../../modules/hetzner.nix
    ../../modules/k9s.nix
    ../../modules/kitty.nix
    ../../modules/ssh.nix
    ../../modules/taskwarrior.nix
    ../../modules/keepassxc.nix
    ../../modules/anki.nix
    ../../modules/photography
    ../../modules/browser
    ../../modules/shell
  ];

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  xdg.userDirs.createDirectories = false;
  xdg.userDirs.download = "${config.home.homeDirectory}/dl";

  browser.primary = "librewolf";

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
