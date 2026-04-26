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
  browser.primary = "librewolf";
  cloud.hetzner.enable = true;
  comms.signal.enable = true;
  git.github.enable = true;
  shell.bash.aliases.lang-js = true;
  shell.bash.addBinToPath = true;

  programs = {
    home-manager.enable = true;
  };

  home.packages = import ../packages.nix {
    inherit pkgs;
    inherit config;
  };
}
