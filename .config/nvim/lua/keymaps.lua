vim.cmd([[
" Leader keys
let mapleader = " "
let maplocalleader = ";"

" Splits & navigation
nm s <c-w>           " Split horizontal
nm ss :sp<CR><c-w>w| " Split horizontal
nm sv :vs<CR><c-w>w| " Split vertical
nm sw <c-w>w|        " Navigate splits
nm sh <c-w>h|        "
nm sj <c-w>j|        "
nm sk <c-w>k|        "
nm sl <c-w>l|        "
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
]])

local set = vim.keymap.set

set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Run `chmod +x` on current file" })
set("n", "yp", "<cmd>let @+ = expand('%r')<CR>:p<CR>", { silent = true, desc = "Yank path" })

-- Remap native NeoVim comment keymaps
set({ "n", "x" }, "<leader>c", "gc", { remap = true, desc = "Toggle comment" })
set("n", "<leader>cc", "gcc", { remap = true, desc = "Toggle comment line" })
set("o", "<leader>c", "gc", { remap = true, desc = "Comment textobject" })

-- Move lines
set("v", "K", ": '<,'>move '<-2<cr>gv")
set("v", "J", ": '<,'>move '>+1<cr>gv")
