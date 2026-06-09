require("claudecode").setup({
  -- terminal = {
  --   provider = "snacks",
  --   snacks_win_opts = {
  --     position = "float",
  --     width = 0.8,
  --     height = 0.8,
  --     border = "rounded",
  --   },
  -- },
  -- diff_opts = {
  --   layout = "vertical",
  -- },
})

local map = vim.keymap.set

map({ "n", "t" }, "<C-_>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
map("n", "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude Code" })
map("n", "<leader>cC", "<cmd>ClaudeCode --continue<cr>", { desc = "Claude Code (continue)" })
map("n", "<leader>cr", "<cmd>ClaudeCode --resume<cr>", { desc = "Claude Code (resume)" })
map("n", "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Claude Code select model" })
map("n", "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add buffer to Claude Code" })
map("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude Code" })
map("n", "<leader>co", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept Claude Code diff" })
map("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny Claude Code diff" })
