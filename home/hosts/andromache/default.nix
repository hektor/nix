{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../modules
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
  ai-tools = {
    claude-code.enable = true;
    opencode.enable = true;
  };
  anki.enable = true;
  audio.enable = true;
  browser.primary = "librewolf";
  cloud.hetzner.enable = true;
  comms.signal.enable = true;
  deploy.enable = true;
  desktop.niri.enable = true;
  devenv.enable = true;
  direnv.enable = true;
  gaming.enable = true;
  git.enable = true;
  git.github.enable = true;
  k8s.k9s.enable = true;
  keepassxc.enable = true;
  music.enable = true;
  nvim.enable = true;
  pandoc.enable = true;
  photography.enable = true;
  reference-manager.enable = true;
  secrets.enable = true;
  shell = {
    enable = true;
    bash.aliases.lang-js = true;
    bash.addBinToPath = true;
  };
  ssh.enable = true;
  taskwarrior.enable = true;
  terminal.enable = true;
  torrenting.enable = true;
  my.yubikey.enable = true;
  zk.enable = true;

  programs = {
    home-manager.enable = true;
    taskwarrior.config.recurrence = lib.mkForce "on";
  };

  home.packages = import ../packages.nix { inherit pkgs; };
}
