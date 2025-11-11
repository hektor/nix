{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.username = "h";
  home.homeDirectory = "/home/h";

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        for f in ${config.home.homeDirectory}/.bashrc.d/*; do
          [ -f "$f" ] && source "$f"
        done

        source ${config.home.homeDirectory}/.bash_aliases/all
        source ${config.home.homeDirectory}/.bash_aliases/lang-js

        # host-specific config goes here
        # ...

        export PATH=${../../../dots/.bin}:$PATH
      '';
    };
    firefox.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    git.enable = true;
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    bash-completion
    bash-language-server
    bat
    brightnessctl
    entr
    eslint_d
    feh
    firefox-devedition
    fzf
    git
    haskell-language-server
    haskellPackages.pandoc-crossref
    haskellPackages.hadolint
    htop
    jq
    keepassxc
    kitty
    lua-language-server
    # neovim
    nixfmt-rfc-style
    nmap
    nodejs_24
    nodePackages.ts-node
    nvimpager
    ormolu
    pandoc
    parallel
    pass
    pnpm
    ripgrep
    silver-searcher
    sshfs
    stylelint
    svelte-language-server
    tailwindcss-language-server
    taskwarrior3
    tldr
    tmux
    tmuxp
    tree
    tree-sitter
    typescript-language-server
    unzip
    vim-language-server
    vimPlugins.vim-plug
    vtsls
    wget
    xbanish
    xclip
    yaml-language-server
  ];

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
