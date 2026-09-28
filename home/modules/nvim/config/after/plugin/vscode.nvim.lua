local function overrides()
  local colors = require("vscode.colors").get_colors()
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.vscLeftDark })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.vscSplitDark, bg = colors.vscLeftDark })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "vscode",
  callback = overrides,
})

if vim.g.colors_name == "vscode" then
  overrides()
end
