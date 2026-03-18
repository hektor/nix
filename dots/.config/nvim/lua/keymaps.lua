vim.g.mapleader = " "
vim.g.maplocalleader = ";"

local set = vim.keymap.set

-- splits & navigation
set("n", "s", "<c-w>", { desc = "window prefix" })
set("n", "ss", ":sp<CR><c-w>w", { desc = "split horizontal" })
set("n", "sv", ":vs<CR><c-w>w", { desc = "split vertical" })
set("n", "sw", "<c-w>w", { desc = "navigate splits" })
set("n", "sh", "<c-w>h", { desc = "focus left split" })
set("n", "sj", "<c-w>j", { desc = "focus below split" })
set("n", "sk", "<c-w>k", { desc = "focus above split" })
set("n", "sl", "<c-w>l", { desc = "focus right split" })
set("n", "sH", "<c-w>8<", { desc = "shrink split left" })
set("n", "sJ", "<c-w>8-", { desc = "shrink split down" })
set("n", "sK", "<c-w>8+", { desc = "grow split up" })
set("n", "sL", "<c-w>8>", { desc = "grow split right" })
set("n", "s=", "<c-w>=", { desc = "equalize splits" })

-- open
set("n", "sb", ":Lex<cr>", { desc = "file tree" })
set("n", "<leader><leader>", ":noh<cr>", { desc = "clear highlights" })
set("n", "<leader>t", ":term<cr>", { desc = "open terminal" })

-- remaps
set("i", "jj", "<esc>", { nowait = true, desc = "exit insert mode" })
set("n", "<left>", "<nop>")
set("n", "<down>", "<nop>")
set("n", "<up>", "<nop>")
set("n", "<right>", "<nop>")
set("i", "<left>", "<nop>")
set("i", "<down>", "<nop>")
set("i", "<up>", "<nop>")
set("i", "<right>", "<nop>")

-- search
set("n", "<c-_>", ":noh<cr>", { desc = "clear search highlight" })

-- line numbers
set("n", "<leader>n", ":set nu! rnu!<cr>", { desc = "toggle line numbers" })

-- vim configuration
set("n", "<leader>ec", ":vs $MYVIMRC<cr>", { desc = "edit vimrc" })
set("n", "<leader>so", ":so %<cr>", { desc = "source current file" })

set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "run `chmod +x` on current file" })
set("n", "yp", "<cmd>let @+ = expand('%r')<CR>:p<CR>", { silent = true, desc = "yank path" })

-- remap native NeoVim comment keymaps
set({ "n", "x" }, "<leader>c", "gc", { remap = true, desc = "toggle comment" })
set("n", "<leader>cc", "gcc", { remap = true, desc = "toggle comment line" })
set("o", "<leader>c", "gc", { remap = true, desc = "comment textobject" })

-- move lines
set("v", "K", ": '<,'>move '<-2<cr>gv", { desc = "move selection up" })
set("v", "J", ": '<,'>move '>+1<cr>gv", { desc = "move selection down" })
