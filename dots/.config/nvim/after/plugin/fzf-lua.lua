local fzf = require("fzf-lua")

fzf.setup({ "max-perf" })

vim.keymap.set("n", "<leader>f<leader>", fzf.builtin) -- Help
vim.keymap.set("n", "<leader>fc", fzf.commands)
vim.keymap.set("n", "<leader>ff", fzf.files)
vim.keymap.set("n", "<leader>fg", fzf.live_grep_native)
vim.keymap.set("n", "<leader>fb", fzf.buffers)
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_workspace)
vim.keymap.set("n", "<leader>fhe", fzf.help_tags)
vim.keymap.set("n", "<leader>fhi", fzf.search_history)
vim.keymap.set("n", "<leader>fma", fzf.marks)
vim.keymap.set("n", "<leader>fmp", fzf.man_pages)

vim.keymap.set("i", "<c-f>", fzf.complete_path)
