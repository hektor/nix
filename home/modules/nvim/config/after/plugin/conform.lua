local nixCatsUtils = require("nixCatsUtils")

local formatters = {
  general = {
    awk = { "awk" },
    html = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    jsonc = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
  },
  c = {
    c = { "clang-format" },
    cpp = { "clang-format" },
  },
  css = { css = { "prettierd", "prettier", stop_after_first = true } },
  gdscript = { gdscript = { "gdformat" } },
  go = { go = { "gofmt" } },
  haskell = { haskell = { "ormolu" } },
  lua = { lua = { "stylua" } }, -- configured in stylua.toml
  nix = { nix = { "nixfmt" } },
  python = { python = { "isort", "black" } },
  rust = { rust = { "rustfmt", lsp_format = "fallback" } },
  shell = { bash = { "shellcheck" } },
  svelte = { svelte = { "eslint_d", "prettierd", "prettier", stop_after_first = true } },
  typescript = {
    javascript = { "biome-check", "eslint_d", "eslint", "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "biome-check", "eslint_d", "eslint", "prettierd", "prettier", stop_after_first = true },
    json = { "biome-check", "prettierd", "prettier", stop_after_first = true },
    jsonc = { "biome-check", "prettierd", "prettier", stop_after_first = true },
    typescript = { "biome-check", "eslint_d", "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "biome-check", "eslint_d", "eslint", "prettierd", "prettier", stop_after_first = true },
  },
  yaml = {
    -- yaml = { "prettierd", "prettier", stop_after_first = true },
  },
}

local formatters_by_ft = {}
for language, language_formatters in pairs(formatters) do
  if language == "general" or nixCatsUtils.enableForCategory("languages." .. language) then
    for ft, ft_formatters in pairs(language_formatters) do
      formatters_by_ft[ft] = ft_formatters
    end
  end
end

require("conform").setup({
  format_after_save = {
    lsp_format = "never",
    timeout_ms = 500,
  },
  formatters = {
    ["biome-check"] = { require_cwd = true },
  },
  formatters_by_ft = formatters_by_ft,
})
