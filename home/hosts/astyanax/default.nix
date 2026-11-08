{
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

  modules."3d".printing.enable = true;
  ai-tools = {
    claude-code.enable = true;
    opencode.enable = true;
  };
  anki.enable = true;
  archiving.enable = true;
  audio.enable = true;
  bin.enable = true;
  browser.enable = true;
  browser.primary = "librewolf";
  cloud.hetzner.enable = true;
  comms.signal.enable = true;
  desktop.niri.enable = true;
  devenv.enable = true;
  direnv.enable = true;
  docker.enable = true;
  git = {
    enable = true;
    gitea.enable = true;
    github.enable = true;
  };
  k8s.k9s.enable = true;
  keepassxc.enable = true;
  mpv.enable = true;
  music.enable = true;
  newsboat.enable = true;
  my.xdg.enable = true;
  my.yubikey.enable = true;
  nfc.enable = true;
  nvim.enable = true;
  pandoc.enable = true;
  reference-manager.enable = true;
  secrets.enable = true;
  shell = {
    enable = true;
    bash.aliases.lang-js = true;
  };
  ssh.enable = true;
  deploy.enable = true;
  taskwarrior.enable = true;
  terminal.enable = true;

  programs = {
    home-manager.enable = true;
  };

  home.packages = import ../packages.nix {
    inherit pkgs;
    inherit config;
  };
}
