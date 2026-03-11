{
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
    ../../modules/nfc
    ../../modules/nvim
    ../../modules/pandoc
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
