" Leader keys
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

" Line numbers
nn <leader>n :set nu! rnu!<cr>

" Vim configuration
nn <leader>ec :vs $MYVIMRC<cr>
nn <leader>so :so %<cr>
