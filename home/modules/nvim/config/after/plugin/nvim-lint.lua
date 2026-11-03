local nixCatsUtils = require("nixCatsUtils")

vim.env.ESLINT_D_PPID = vim.fn.getpid()

local eslint_linter = "eslint_d"

local linters = {
  general = {
    cmake = { "cmakelint" },
    editorconfig = { "editorconfig-checker" },
    latex = { "chktex" },
    make = { "checkmake" },
    -- pandoc = { "proselint", "woke" },
    systemd = { "systemdlint" },
  },
  c = {
    c = { "clangtidy", "flawfinder" },
    cpp = { "clangtidy", "flawfinder" }, -- "cpplint", "cppcheck", "flawfinder"
  },
  css = { css = { "stylelint" } },
  docker = { dockerfile = { "hadolint" } },
  gdscript = { gdscript = { "gdlint" } },
  haskell = { haskell = { "hlint" } },
  html = {
    -- html = { "htmlhint" },
  },
  lua = {
    -- lua = { "luacheck", "selene" },
  },
  python = {
    -- python = { "pylint" },
  },
  shell = {
    bash = { "shellcheck" },
    sh = { "shellcheck" },
  },
  svelte = { svelte = { eslint_linter } },
  typescript = {
    -- javascript = { eslint_linter },
    -- javascriptreact = { eslint_linter },
    -- typescript = { eslint_linter },
    -- typescriptreact = { eslint_linter },
  },
  yaml = { yaml = { "yamllint" } },
}

local linters_by_ft = {}
for language, language_linters in pairs(linters) do
  if language == "general" or nixCatsUtils.enableForCategory("languages." .. language) then
    for ft, ft_linters in pairs(language_linters) do
      linters_by_ft[ft] = ft_linters
    end
  end
end

require("lint").linters_by_ft = linters_by_ft

local function has_yamllint_config(buf)
  return vim.fs.root(buf, { ".yamllint", ".yamllint.yaml", ".yamllint.yml" }) ~= nil
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("nvim-lint.try_lint", {}),
  callback = function(args)
    if vim.bo[args.buf].filetype == "yaml" and not has_yamllint_config(args.buf) then
      return
    end
    require("lint").try_lint()
  end,
})
