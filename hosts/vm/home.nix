{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.username = "h";
  home.homeDirectory = "/home/h";

  programs = {
    bash = {
      enable = true;
      # TODO
    };
    firefox.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
      defaultCommand = "ag -g '' --hidden ";
      defaultOptions = [
        "--pointer=❭"
        "--height=10%"
        "--color=fg:-1,bg:-1"
      ];
      fileWidgetCommand = "ag -g '' --hidden ";
      fileWidgetOptions = [ "--preview='bat {} | head -500'" ];
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
    iosevka
    jq
    keepassxc
    kitty
    lua-language-server
    neovim
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

  home.file.".inputrc".source = ../../dots/.inputrc;
}
