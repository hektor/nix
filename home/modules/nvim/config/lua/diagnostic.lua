-- Source: <https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/>
vim.diagnostic.config({
  signs = true,
  underline = false,
  severity_sort = true,
})

vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dj", function()
  vim.diagnostic.jump({ count = -1, float = true })
end)
vim.keymap.set("n", "<leader>dk", function()
  vim.diagnostic.jump({ count = 1, float = true })
end)
