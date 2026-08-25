vim.opt.background = "dark"

if vim.g.vscode then
  return
end

vim.g.zenwritten_compat = 1
vim.cmd.colorscheme(require("nixCatsUtils").getCatOrDefault("colorscheme", "zenwritten"))
