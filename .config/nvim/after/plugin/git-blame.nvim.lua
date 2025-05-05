local gitblame = require("gitblame")

gitblame.setup({
  enabled = false,
  date_format = "%r",
  message_template = "  [<date> (<author>) <sha> <summary>]",
  message_when_not_committed = "  [Uncommitted changes]",
  delay = 250,
})

-- vim.g.gitblame_virtual_text_column = 80
