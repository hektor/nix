require("diffview").setup({
  keymaps = {
    file_panel = {
      ["s"] = false, -- would conflict with "splits & navigation" keymaps
    },
  },
})

local map = vim.keymap.set

map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "git history (repo)" })
map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "git history (file)" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "git diff" })
