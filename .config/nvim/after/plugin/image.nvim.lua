require("image").setup({
  processor = "magick_cli",
  integrations = {
    markdown = {
      filetypes = { "markdown", "pandoc" },
    },
  },
})
