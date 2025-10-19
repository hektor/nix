require("nixCatsUtils").setup({ non_nix_value = true }) -- https://github.com/BirdeeHub/nixCats-nvim/blob/77dffad8235eb77684fcb7599487c8e9f23d5b8f/templates/example/init.lua

vim.cmd([[
set termguicolors
set bg=light
hi Normal ctermbg=none guibg=NONE
]])

require("base")
require("plug")
require("ftdetect")
require("keymaps")
require("highlight")
require("diagnostic")

require("paq-setup") -- when not on nixCats

-- vim.opt.background = "dark"
-- vim.opt.laststatus = 3
