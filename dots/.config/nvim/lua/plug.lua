if not vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] then
  local vim = vim
  local Plug = vim.fn["plug#"]

  vim.call("plug#begin")

  Plug("machakann/vim-sandwich")
  Plug("Shougo/context_filetype.vim")
  Plug("editorconfig/editorconfig-vim")
  Plug("honza/vim-snippets")
  Plug("chrisbra/unicode.vim")
  Plug("ap/vim-css-color")
  -- Jupyter
  Plug("quarto-dev/quarto-vim")
  -- LaTeX
  Plug("lervag/vimtex")
  -- Wiki
  Plug("lervag/wiki.vim")
  -- Markdown
  Plug("vim-pandoc/vim-pandoc")
  Plug("vim-pandoc/vim-pandoc-syntax")
  Plug("ferrine/md-img-paste.vim")
  -- TidalCycles
  Plug("supercollider/scvim")
  Plug("tidalcycles/vim-tidal")
  -- GLSL
  Plug("tikhomirov/vim-glsl")
  Plug("timtro/glslView-nvim")
  -- Jupyter notebooks
  Plug("goerz/jupytext.vim")
  -- OpenSCAD
  Plug("sirtaj/vim-openscad")

  vim.call("plug#end")
end
