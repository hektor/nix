require("conform").setup({
  format_after_save = {
    lsp_fallback = false,
    async = false,
    timeout_ms = 500,
  },
  formatters_by_ft = {
    awk = { "awk" },
    bash = { "shellcheck" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    css = { "prettierd", "prettier", stop_after_first = true },
    gdscript = { "gdformat" },
    haskell = { "ormolu" },
    html = { "prettierd", "prettier", stop_after_first = true },
    lua = { "stylua" }, -- configured in stylua.toml
    markdown = { "prettierd", "prettier", stop_after_first = true },
    nix = { "nixfmt" },
    javascript = { "eslint_d", "eslint", "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "eslint_d", "eslint", "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    jsonc = { "prettierd", "prettier", stop_after_first = true },
    python = { "isort", "black" },
    svelte = { "eslint_d", "prettierd", "prettier", stop_after_first = true },
    typescript = { "eslint_d", "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "eslint_d", "eslint", "prettierd", "prettier", stop_after_first = true },
    -- yaml = { "prettierd", "prettier", stop_after_first = true },
  },
})
