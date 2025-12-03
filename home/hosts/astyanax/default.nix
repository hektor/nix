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
    ../../modules/dconf.nix # TODO: Only enable when on Gnome?
    ../../modules/git.nix
    ../../modules/k9s.nix
    (import ../../modules/taskwarrior.nix {
      inherit config;
      inherit pkgs;
    })
  ];

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  xdg.userDirs.createDirectories = false;
  xdg.userDirs.download = "${config.home.homeDirectory}/dl";

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        for f in /home/h/.bashrc.d/*; do
          [ -f "$f" ] && source "$f"
        done

        source /home/h/.bash_aliases/all
        source /home/h/.bash_aliases/lang-js

        # host-specific config goes here
        # ...

        export PATH=${../../../dots/.bin}:$PATH
      '';
    };
    firefox = import ../../modules/firefox.nix {
      inherit inputs;
      inherit pkgs;
      inherit config;
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    home-manager.enable = true;
    keepassxc = import ../../modules/keepassxc.nix;
  };

  home.packages = import ./packages.nix {
    inherit pkgs;
    inherit config;
  };

  home.file = {
    ".inputrc".source = ../../../dots/.inputrc;
    ".bashrc.d/prompt".source = ../../../dots/.bashrc.d/prompt;
    ".bashrc.d/editor".source = ../../../dots/.bashrc.d/editor;
    ".bash_aliases/all".source = ../../../dots/.bash_aliases/all;
    ".bash_aliases/lang-js".source = ../../../dots/.bash_aliases/lang-js;
    ".config/kitty/kitty.conf".source = ../../../dots/.config/kitty/kitty.conf;
    ".config/kitty/themes/zenwritten_light.conf".source =
      ../../../dots/.config/kitty/themes/zenwritten_light.conf;
    ".config/kitty/themes/zenwritten_dark.conf".source =
      ../../../dots/.config/kitty/themes/zenwritten_dark.conf;
  };
}
