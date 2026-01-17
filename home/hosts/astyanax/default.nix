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
    ../../modules/anki.nix
    ../../modules/desktop/niri
    ../../modules/git.nix
    ../../modules/k9s.nix
    ../../modules/taskwarrior.nix
    ../../modules/keepassxc.nix
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
  };

  home.packages = import ../packages.nix {
    inherit pkgs;
    inherit config;
  };

  home.file = {
    ".config/kitty/kitty.conf".source = ../../../dots/.config/kitty/kitty.conf;
    ".config/kitty/themes/zenwritten_light.conf".source =
      ../../../dots/.config/kitty/themes/zenwritten_light.conf;
    ".config/kitty/themes/zenwritten_dark.conf".source =
      ../../../dots/.config/kitty/themes/zenwritten_dark.conf;
  };
}
