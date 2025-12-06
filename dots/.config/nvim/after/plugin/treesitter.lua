local ts = require("treesj")
local vim = vim
local keymap = vim.keymap
local opt = vim.opt
local treesitter_configs = require("nvim-treesitter.configs")

local nixCatsUtils = require("nixCatsUtils")
local is_nix = nixCatsUtils.isNixCats

treesitter_configs.setup({
  -- Basically added what I might need from the docs
  -- <https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages>
  ensure_installed = is_nix and {} or {
    "awk",
    "bash",
    "bibtex",
    "c",
    "cmake",
    "comment",
    "cpp",
    "css",
    "csv",
    "diff",
    "dockerfile",
    "dot",
    "gdscript",
    "gdshader",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "glsl",
    "gnuplot",
    "go",
    "godot_resource",
    "gpg",
    "graphql",
    "haskell",
    "html",
    "java",
    "javascript",
    "jq",
    "jsdoc",
    "json",
    "jsonc",
    "latex",
    "lua",
    "luadoc",
    "make",
    "python",
    "query",
    "r",
    "racket",
    "readline",
    "regex",
    "requirements",
    "scheme",
    "scss",
    "sql",
    "ssh_config",
    "supercollider",
    "svelte",
    "tmux",
    "toml",
    "tsv",
    "tsx",
    "typescript",
    "udev",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zathurarc",
  },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "vv",
      node_incremental = "vv",
      scope_incremental = "VV",
      node_decremental = "vd",
    },
  },
  indent = {
    enable = true,
  },
  sync_install = false,
  auto_install = not is_nix,
  ignore_install = {},
  modules = {},
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- Functions
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["ip"] = "@parameter.inner",
        ["ap"] = "@parameter.outer",
      },
    },
  },
  node_movement = {
    enable = true,
    keymaps = {
      move_up = "vk",
      move_down = "vj",
      move_left = "vh",
      move_right = "vl",
      swap_left = "vH",
      swap_right = "vL",
      select_current_node = "vi",
    },
    swappable_textobjects = { "@function.outer", "@parameter.inner", "@statement.outer" },
    allow_switch_parents = true,
    allow_next_parent = true,
  },
})

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false

-- TreeSJ
require("treesj").setup({
  use_default_keymaps = false,
})

keymap.set("n", ";", ts.toggle, { desc = "Toggle join/split (TreeTSJ)" })
