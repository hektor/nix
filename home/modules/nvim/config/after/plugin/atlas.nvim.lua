local nixCatsUtils = require("nixCatsUtils")
local atlas = require("atlas")

local providers = {}

if nixCatsUtils.enableForCategory("github") then
  providers.github = {}
end

if nixCatsUtils.enableForCategory("gitlab") then
  providers.gitlab = { base_url = "https://gitlab.com", token = vim.env.GITLAB_API_ACCESS_TOKEN }
end

atlas.setup({
  providers = providers,
  pulls = {
    diff = {
      open_cmd = "AtlasDiff",
      layout = "side-by-side",
      lsp = { enabled = true, link = { "node_modules" } },
    },
  },
})

local map = vim.keymap.set

map("n", "<leader>gp", "<cmd>Atlas pulls<cr>", { desc = "pull requests (atlas)" })
map("n", "<leader>gi", "<cmd>Atlas issues<cr>", { desc = "issues (atlas)" })
map("n", "<leader>gr", "<cmd>Atlas review<cr>", { desc = "review pull request (atlas)" })
