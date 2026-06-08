vim.env.ESLINT_D_PPID = vim.fn.getpid()

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
