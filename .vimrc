" General config {{{
"
" Tip: acronyms for overview, use `:h` for a quick lookup.

set nocp                               " Disable vi incompatibility
filetype plugin indent on              " Filetype recognition
set enc=utf8                           " Default to UTF-8 encoding
set hid                                " Allow hiding unsaved buffers
set tf                                 " Fast tty
set ut=300                             " 300ms for update time
set to tm=200 ttm=5                    " Timeouts
set shm+=c                             " ...
set ul=500 hi=500                      " History and undo
set nu rnu scl=number                  " Line numbers & signs
set nowrap
set bs=indent,eol,start                " Indentation
set ai ts=2 sts=2 sw=2 et              " Indentation
set is ic scs hls                      " Search
set lz                                 " Only essential redraws
set nobk nowb noswf                    " No backups
set vi='20,\"101                       " Max 100 lines in registers
set novb                               " Bell
set cole=0 cocu=""                     " Conceal
set cb=unnamedplus                     " Clipboard
set fcs+=vert:│                        " Cleaner split separator (tmux style)
set list
set lcs=trail:·,tab:→\ ,nbsp:␣         " Whitespace rendering
set ar                                 " Autoread
set spellsuggest+=5                    " Limit spell suggestions
set wildignore+=*/node_modules/*,*/tmp/*,*.so,*.swp,*.zip
set thesaurus+=~/.vim/thesaurus/mthesaur.txt

" }}}

" Mappings {{{
"

" Leader keys

nn <space><nop>
let mapleader = " "
let maplocalleader = ";"

" Splits & navigation

nm s <c-w>           " Split horizontal
nm ss :sp<CR><c-w>w| " Split horizontal
nm sv :vs<CR><c-w>w| " Split vertical
nn sw <c-w>w|        " Navigate splits
nn sh <c-w>h|        "
nn sj <c-w>j|        "
nn sk <c-w>k|        "
nn sl <c-w>l|        "
nn sH <c-w>8<|       " Resize splits
nn sJ <c-w>8-|       "
nn sK <c-w>8+|       "
nn sL <c-w>8>|       "
nn s= <c-w>=|        " Equalize splits

" Open

nn sb :Lex<cr>|          " File tree
nn <leader><leader> :noh<cr> |"
nn <leader>t :term<cr>| " Open terminal
" Remaps
ino <nowait> jj <esc>|   " Normal now
nn  <left>  <nop>|       " Hard mode
nn  <down>  <nop>|       " "
nn  <up>    <nop>|       " "
nn  <right> <nop>|       " "
ino <left>  <nop>|       " "
ino <down>  <nop>|       " "
ino <up>    <nop>|       " "
ino <right> <nop>|       " "
" Search
nn <c-_> :noh<cr>| " map 'ctrl + /'
" Toggle line numbers
nn <leader>n :set nu! rnu!<cr>
" Vim configuration
nn <leader>ec :vs $MYVIMRC<cr>
nn <leader>so :so %<cr>

" }}}

" Plugins {{{

" Plug setup {{{

call plug#begin()
if !exists('g:vscode')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'
endif
" General
Plug 'unblevable/quick-scope'
Plug 'Shougo/context_filetype.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'machakann/vim-sandwich'
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

" Plugin config {{{

" }}}


" `.../vimtex` {{{

let g:vimtex_view_method='zathura'
let g:tex_flavor='latex'
let g:tex_conceal='abdmgs'
let g:vimtex_quickfix_mode=0

" }}}

" `junegunn/fzf` {{{
" `junegunn/fzf.vim`

" FZF
nn <c-p> :FZF<cr>
nn <leader>p :FZF<cr>
nn <leader>b :Buffers<cr>
nn <leader>h :History<cr>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" Insert path completion
" ino <expr><c-f> fzf#vim#complete#path('ag -l -g *.md')
" ino <c-f> <plug>(fzf-complete-file-ag)
ino <expr><c-f> fzf#vim#complete#path("ag -l -g '' \| sed -e 's/\.md$//'")
" Use `the_silver_searcher` to find results (for selection if selection)
nn <leader>f :Ag<cr>
vm <leader>f :Ag <C-r>"<cr>

" }}}



" }}}

" `tools-life/taskwiki` {{{

let g:taskwiki_taskrc_location='/home/h/.config/task/taskrc'
let g:taskwiki_disable_concealcursor=1
let g:taskwiki_dont_preserve_folds=1
let g:taskwiki_dont_fold=1

" }}}

" `pangloss/vim-javascript` {{{

let g:javascript_plugin_jsdoc = 1 " jsdoc syntax highlighting
let g:javascript_plugin_flow = 1 " flow syntax highlighting
let g:javascript_conceal_function = "ƒ"
let g:javascript_conceal_return = "⇖"
let g:svelte_indent_script = 0
let g:svelte_indent_style = 0

" }}}

" `.../quickscope` {{{

let g:qs_max_chars=80
let g:qs_lazy_highlight = 1

" }}}


" Tidalcycles (sclang and vim-tidal)
let g:tidal_default_config = {"socket_name": "default", "target_pane": "tidal:1.1"}
let g:tidal_no_mappings = 1

au FileType tidal nm <buffer> <leader>ep <Plug>TidalParagraphSend
au FileType tidal nm <buffer> <leader>ee <Plug>TidalLineSend
au FileType tidal nnoremap <buffer> <leader>h :TidalHush<cr>
au FileType tidal com! -nargs=1 S :TidalSilence <args>
au FileType tidal com! -nargs=1 P :TidalPlay <args>
au FileType tidal com! -nargs=0 H :TidalHush

" SuperCollider
au BufEnter,BufWinEnter,BufNewFile,BufRead *.sc,*.scd se filetype=supercollider
au Filetype supercollider packadd scvim

" }}}


" }}}

" Color theme & statusline {{{
"

se ls=2
se stl=\ %0*%n
se stl+=\ %m
se stl+=\ %y%0*
se stl+=\ %<%F
se stl+=\ %0*%=%5l%*
se stl+=%0*/%L%*

colo yang

" }}}

" Quick hacks {{{
"

fu! Compile()
  if expand('%:e') == "md" 
    :silent exec "!pandoc % -s -o /tmp/op.pdf &"
  endif
endfu

fu! Preview()
  :call Compile()
  :silent exec "!zathura /tmp/op.pdf &"
endfu

" VIM config hot reload

" TODO: separate to filetype specific files

" JS
" Jump between `=` and `;`
au FileType javascript set mps+==:;

" JSONC (see https://github.com/neoclide/jsonc.vim/pull/9")
au BufNewFile,BufRead */.vscode/*.json setlocal filetype=jsonc

let s:zk_preview_enabled = 0
let s:live_server_job = -1
au BufEnter /home/h/.zk/*.md silent exe '!echo "%" > /home/h/.zk/current-zettel.txt'
function! ToggleZKPreview()
    if s:zk_preview_enabled == 1
        let s:zk_preview_enabled = 0
        call jobstop(s:live_server_job)
        au! ZKPreview
    else
        let s:zk_preview_enabled = 1
        let s:live_server_job = jobstart('live-server --watch=/home/h/.zk/current-zettel-content.html --open=current-zettel-content.html --port=8080')
        augroup ZKPreview
          au BufEnter /home/h/.zk/*.md silent exe '!cat "%:r.html" > /home/h/.zk/current-zettel-content.html'
          au BufWritePost /home/h/.zk/*.md silent exe '!make && cat "%:r.html" > /home/h/.zk/current-zettel-content.html'
        augroup END
    endif
endfunction
command! ToggleZKPreview call ToggleZKPreview()

nn <leader>o :ToggleZKPreview<cr> :!xdg-open http://localhost:8080/%:t:r.html & <cr>

highlight QuickScopeSecondary cterm=underline
highlight QuickScopePrimary ctermbg=253 ctermfg=232 cterm=none
highlight Pmenu ctermfg=232

" Taken from /usr/share/vim/vim90/defaults.vim
augroup vimStartup
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim) and for a commit message (it's
  " likely a different one than last time).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

augroup END

augroup Vim
  au!
  " Reload vim config when ~/.vimrc is changed
  au BufWritePost $HOME/.vimrc so $MYVIMRC | redraw | echo "Reloaded vimrc"
augroup END
