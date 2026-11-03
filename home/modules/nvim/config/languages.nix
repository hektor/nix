{
  pkgs,
  categories ? { },
}:

with pkgs;
{
  c = {
    enable = false;
    packages = [
      clang
      clang-tools
    ];
  };
  css = {
    enable = false;
    packages = [
      stylelint
      vscode-langservers-extracted
    ];
  };
  docker = {
    enable = false;
    packages = [
      dockerfile-language-server
      hadolint
    ];
  };
  gdscript = {
    enable = false;
    packages = [ gdtoolkit_4 ];
  };
  go = {
    enable = false;
    packages = [
      go
      gopls
    ];
  };
  haskell = {
    enable = false;
    packages = [
      haskell-language-server
      hlint
      ormolu
    ];
  };
  helm = {
    enable = false;
    packages = [ helm-ls ];
    plugins = [ vimPlugins.helm-ls-nvim ];
  };
  html = {
    enable = false;
    packages = [
      emmet-language-server
      vscode-langservers-extracted
    ];
  };
  json = {
    enable = false;
    packages = [ vscode-langservers-extracted ];
  };
  lua = {
    enable = true;
    packages = [
      lua-language-server
      stylua
    ];
  };
  nix = {
    enable = true;
    packages = [
      nixd
      nixfmt
    ];
  };
  openscad = {
    enable = false;
    packages = [ openscad-lsp ];
    plugins = [ vimPlugins.vim-openscad ];
  };
  python = {
    enable = false;
    packages = [
      black
      isort
      pyright
    ];
  };
  rust = {
    enable = false;
    packages = [
      rust-analyzer
      rustfmt
    ];
    plugins = [ vimPlugins.rustaceanvim ];
  };
  shell = {
    enable = true;
    packages = [
      bash-language-server
      shellcheck-minimal
    ];
  };
  svelte = {
    enable = false;
    packages = [
      eslint_d
      svelte-language-server
    ];
  };
  tailwind = {
    enable = false;
    packages = [ tailwindcss-language-server ];
    plugins = [ neovimPlugins.tailwind-fold-nvim ];
  };
  typescript = {
    enable = false;
    packages = [
      eslint_d
      (if (categories.typescriptServer or "ts_ls") == "vtsls" then vtsls else typescript-language-server)
      vscode-langservers-extracted
    ];
  };
  yaml = {
    enable = false;
    packages = [
      yaml-language-server
      yamllint
    ];
  };
}
