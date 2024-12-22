" Plugins {{{

" Plug setup {{{

call plug#begin()
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-sandwich'
Plug 'Shougo/context_filetype.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'honza/vim-snippets'
Plug 'chrisbra/unicode.vim'
Plug 'ap/vim-css-color'
" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" JS and TypeScript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }
Plug 'peitalin/vim-jsx-typescript', { 'for': ['typescript.tsx'] }
Plug 'evanleck/vim-svelte', {'branch': 'main'}
" JSON with comments
Plug 'neoclide/jsonc.vim'
" Jupyter
Plug 'quarto-dev/quarto-vim'
" LaTeX
Plug 'lervag/vimtex'
" Wiki
Plug 'lervag/wiki.vim'
Plug 'hektor/taskwiki'
" Markdown
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'ferrine/md-img-paste.vim'
" TidalCycles
Plug 'supercollider/scvim'
Plug 'tidalcycles/vim-tidal'
" GLSL
Plug 'tikhomirov/vim-glsl'
Plug 'timtro/glslView-nvim'
" Jupyter notebooks
Plug 'goerz/jupytext.vim'
" OpenSCAD
Plug 'sirtaj/vim-openscad'
call plug#end()
" }}}
