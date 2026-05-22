{
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
    ../../modules/nfc
    ../../modules/nvim
    ../../modules/pandoc
    ../../modules/secrets
    ../../modules/shell
    ../../modules/ssh
    ../../modules/taskwarrior
    ../../modules/terminal
    ../../modules/yubikey
  ];

  home = {
    stateVersion = "25.05";
    inherit (config.host) username;
    homeDirectory = "/home/${config.host.username}";
  };

  xdg.userDirs = {
    enable = false;
    createDirectories = false;
  };

  modules."3d".printing.enable = true;
  ai-tools = {
    claude-code.enable = true;
    opencode.enable = true;
  };
  browser.enable = true;
  browser.primary = "librewolf";
  cloud.hetzner.enable = true;
  comms.signal.enable = true;
  git.github.enable = true;
  shell = {
    enable = true;
    bash.aliases.lang-js = true;
    bash.addBinToPath = true;
  };
  anki.enable = true;
  k8s.k9s.enable = true;
  taskwarrior.enable = true;
  secrets.enable = true;
  my.yubikey.enable = true;
  audio.enable = true;
  ssh.enable = true;
  music.enable = true;
  terminal.enable = true;
  devenv.enable = true;
  keepassxc.enable = true;
  direnv.enable = true;
  nvim.enable = true;
  nfc.enable = true;
  pandoc.enable = true;

  programs = {
    home-manager.enable = true;
  };

  home.packages = import ../packages.nix {
    inherit pkgs;
    inherit config;
  };
}
