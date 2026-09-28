local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local function yank_highlight()
  vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
end

-- Yanked text highlight feedback (source: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua)
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = "YankHighlight",
  callback = yank_highlight,
})
