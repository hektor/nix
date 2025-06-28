local gitsigns = require("gitsigns")

gitsigns.setup({
  current_line_blame_opts = { delay = 0 },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
})

vim.api.nvim_create_user_command("Blame", gitsigns.toggle_current_line_blame, { nargs = "?" })
