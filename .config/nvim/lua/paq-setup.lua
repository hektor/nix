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
  { "ibhagwan/fzf-lua" },
  { "barreiroleo/ltex_extra.nvim" },
  { "neovim/nvim-lspconfig" },
  { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
  { "linrongbin16/lsp-progress.nvim" },
  { "folke/neodev.nvim" }, -- Nvim
  { "b0o/schemastore.nvim" }, -- JSON Schemas
  { "mfussenegger/nvim-lint" },
  { "stevearc/conform.nvim" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "stevearc/dressing.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "folke/trouble.nvim" },
  { "rktjmp/shipwright.nvim" }, -- For building themes based on lush (e.g. terminal)
  { "rktjmp/lush.nvim" },
  { "mcchrish/zenbones.nvim" }, -- Zenbones themes (contains zenwritten)
  { "theHamsta/crazy-node-movement" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  -- { "nvim-treesitter/nvim-treesitter-context" },
  { "JoosepAlviste/nvim-ts-context-commentstring" }, -- commentstring based on cursor position (e.g. for Svelte)
  { "Wansmer/treesj" },
  { "michaelb/sniprun", build = "sh install.sh" },
  { "f-person/git-blame.nvim" },
  { "brenoprata10/nvim-highlight-colors" },
  { "razak17/tailwind-fold.nvim" },
  { "rmagatti/auto-session" },
  { "kndndrj/nvim-dbee" },
  { "3rd/image.nvim", build = false },
  { "polarmutex/beancount.nvim" },
  { "jamesblckwell/nvimkit.nvim" },
  { 'olimorris/codecompanion.nvim' },
  { "ravitemer/mcphub.nvim",                       build = "pnpm install -g mcp-hub@latest" },
  { "zbirenbaum/copilot.lua" },
  { "zbirenbaum/copilot-cmp" }
})
-- }}}
