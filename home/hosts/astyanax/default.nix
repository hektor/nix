{
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
    ../../modules/anki.nix
    ../../modules/desktop/niri
    ../../modules/git.nix
    # ../../modules/hetzner.nix
    ../../modules/k9s.nix
    ../../modules/kitty.nix
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

  browser.primary = "librewolf";

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
