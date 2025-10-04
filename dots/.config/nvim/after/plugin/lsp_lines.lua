require("lsp_lines").setup()

vim.diagnostic.config({
  virtual_text = false,
})

vim.keymap.set("", "<leader>dd", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
