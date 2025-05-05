require("conform").setup({
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  },
  formatters_by_ft = {
    awk = { "awk" },
    bash = { "shellcheck" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    css = { "prettierd", "prettier" },
    gdscript = { "gdformat" },
    haskell = { "ormolu" },
    html = { "prettierd", "prettier" },
    lua = { "stylua" }, -- configured in stylua.toml
    markdown = { "prettierd", "prettier" },
    javascript = { "prettierd", "prettier" },
    javascriptreact = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    jsonc = { "prettierd", "prettier" },
    python = { "isort", "black" },
    svelte = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    typescriptreact = { "prettierd", "prettier" },
    yaml = { "prettierd", "prettier" },
  },
})
