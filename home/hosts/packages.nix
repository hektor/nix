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
  nvimpager
  pandoc
  parallel
  pass
  pnpm
  python3
  ripgrep
  silver-searcher
  sops
  sshfs
  tldr
  tree
  unzip
  vimPlugins.vim-plug
  wget
]
