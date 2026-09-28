local vim = vim
local api = vim.api
local keymap = vim.keymap
local opt = vim.opt
local treesitter = require("nvim-treesitter")
local textobjects = require("nvim-treesitter-textobjects")
local select = require("nvim-treesitter-textobjects.select")
local treesj = require("treesj")

local is_nix = require("nixCatsUtils").isNixCats

if not is_nix then
  treesitter.install({
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
  })
end

-- https://github.com/MeanderingProgrammer/treesitter-modules.nvim#implementing-yourself
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("treesitter.setup", {}),
  callback = function(args)
    local buf = args.buf
    local filetype = args.match
    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if not (language and vim.treesitter.language.add(language)) then
      return
    end
    -- fold
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- highlight
    vim.treesitter.start(buf, language)
    -- indent
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = false

-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/main/README.md#text-objects-select
textobjects.setup({
  select = {
    lookahead = true,
  },
})

local function select_textobject(capture)
  return function()
    select.select_textobject(capture, "textobjects")
  end
end

keymap.set({ "x", "o" }, "if", select_textobject("@function.inner"), { desc = "Inner function" })
keymap.set({ "x", "o" }, "af", select_textobject("@function.outer"), { desc = "A function" })
keymap.set({ "x", "o" }, "ip", select_textobject("@parameter.inner"), { desc = "Inner parameter" })
keymap.set({ "x", "o" }, "ap", select_textobject("@parameter.outer"), { desc = "A parameter" })

treesj.setup({
  use_default_keymaps = false,
})

keymap.set("n", ";", treesj.toggle, { desc = "Toggle join/split (TreeSJ)" })
