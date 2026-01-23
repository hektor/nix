{ pkgs, ... }:

with pkgs;
[
  bash-completion
  bat
  entr
  feh
  fzf
  gh
  git
  haskellPackages.pandoc-crossref
  htop
  jq
  nixfmt-rfc-style
  nmap
  nodejs_24
  opencode
  nvimpager
  pandoc
  parallel
  pass
  pnpm
  python3
  ripgrep
  signal-desktop
  silver-searcher
  sops
  sshfs
  tldr
  tree
  unzip
  vimPlugins.vim-plug
  wget
]
