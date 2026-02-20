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
    ../../modules/lib.nix
    ../../modules/ai-tools.nix
    ../../modules/audio
    ../../modules/anki.nix
    ../../modules/cloud
    ../../modules/comms
    ../../modules/direnv
    ../../modules/desktop/niri
    ../../modules/git
    ../../modules/k8s/k9s.nix
    ../../modules/kitty.nix
    ../../modules/music
    ../../modules/nfc
    ../../modules/nvim.nix
    ../../modules/ssh.nix
    ../../modules/taskwarrior.nix
    ../../modules/keepassxc.nix
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

  ai-tools.opencode.enable = true;
  browser.primary = "librewolf";
  cloud.hetzner.enable = true;
  comms.signal.enable = true;
  github.enable = true;
  nfc.proxmark3.enable = true;

  shell.bash = {
    enable = true;
    aliases.lang-js = true;
  };

  programs = {
    home-manager.enable = true;
  };

  home.packages = import ../packages.nix {
    inherit pkgs;
    inherit config;
  };
}
