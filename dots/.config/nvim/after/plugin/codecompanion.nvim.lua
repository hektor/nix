require("codecompanion").setup({
  ignore_warnings = true,
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true,
      },
    },
  },
  strategies = {
    chat = { adapter = "openai" },
    inline = { adapter = "openai" },
  },
})
