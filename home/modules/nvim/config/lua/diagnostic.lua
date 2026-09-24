-- Source: <https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/>
vim.diagnostic.config({
  signs = true,
  underline = false,
  severity_sort = true,
  virtual_text = false,
})

vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dj", function()
  vim.diagnostic.jump({ count = -1, float = true })
end)
vim.keymap.set("n", "<leader>dk", function()
  vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("", "<leader>dd", function()
  vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
end, { desc = "toggle diagnostic virtual lines" })
