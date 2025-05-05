-- Automate paq installation {{{
local function clone_paq()
  local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path })
    return true
  end
end
local function bootstrap_paq(packages)
  local first_install = clone_paq()
  vim.cmd.packadd("paq-nvim")
  local paq = require("paq")
  if first_install then
    vim.notify("Installing plugins... If prompted, hit Enter to continue.")
  end
  paq(packages)
  paq.install()
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local pkgs_count = #require("paq").query("to_install")
    if pkgs_count < 1 then
      return
    end
    vim.notify(string.format("There are %d to install", pkgs_count))
  end,
})

-- }}}

-- Set up paq plugins {{{
bootstrap_paq({
  { "savq/paq-nvim" },
-- }}}
