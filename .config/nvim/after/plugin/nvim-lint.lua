local eslint_linter = "eslint_d"

require("lint").linters_by_ft = {
  bash = { "shellcheck" },
  c = { "clangtidy", "flawfinder" },
  cmake = { "cmakelint" },
  cpp = { "clangtidy", "flawfinder" }, -- "cpplint", "cppcheck", "flawfinder"
  css = { "stylelint" },
  dockerfile = { "hadolint" },
  editorconfig = { "editorconfig-checker" },
  haskell = { "hlint" },
  -- html = { "htmlhint" },
  -- javascript = { eslint_linter },
  -- javascriptreact = { eslint_linter },
  gdscript = { "gdlint" },
  latex = { "chktex" },
  -- lua = { "luacheck", "selene" },
  make = { "checkmake" },
  -- pandoc = { "proselint", "woke" },
  -- python = { "pylint" },
  sh = { "shellcheck" },
  svelte = { eslint_linter },
  systemd = { "systemdlint" },
  -- typescript = { eslint_linter },
  -- typescriptreact = { eslint_linter },
  yaml = { "yamllint" },
}

-- TODO: Wouldn't it be possible / nice to only try to load the linters when they are
-- actually needed?

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
