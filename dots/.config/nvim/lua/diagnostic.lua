-- Source: <https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/>
vim.diagnostic.config({
  signs = true,
  underline = false,
  severity_sort = true,
})

vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_next)
