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
