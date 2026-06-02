require("codecompanion").setup({
  ignore_warnings = true,
  strategies = {
    chat = { adapter = "openai" },
    inline = { adapter = "openai" },
  },
})
