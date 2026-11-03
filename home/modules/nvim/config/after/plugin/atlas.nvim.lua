local nixCatsUtils = require("nixCatsUtils")
local atlas = require("atlas")

local githubEnabled = nixCatsUtils.enableForCategory("github")

atlas.setup({
  providers = githubEnabled and { github = {} } or {},
  pulls = { diff = { open_cmd = "AtlasDiff" } },
})

local map = vim.keymap.set

map("n", "<leader>gp", "<cmd>Atlas pulls<cr>", { desc = "pull requests (atlas)" })
map("n", "<leader>gi", "<cmd>Atlas issues<cr>", { desc = "issues (atlas)" })
map("n", "<leader>gr", "<cmd>Atlas review<cr>", { desc = "review pull request (atlas)" })
