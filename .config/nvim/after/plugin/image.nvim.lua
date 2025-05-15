require("image").setup({
  backend = "kitty",
  kitty_method = "normal",
  processor = "magick_cli",
  integrations = {
    markdown = {
      filetypes = { "markdown", "pandoc" },
    },
  },
})
