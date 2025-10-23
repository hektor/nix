require("neodev").setup() -- should setup before lspconfig

local lspconfig = require("lspconfig")

-- vim.g.coq_settings = { auto_start = 'shut-up' }
-- local capabilities = coq.lsp_ensure_capabilities()

local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

local servers = {
  bashls = {},
  eslint = {
    settings = {
      --Assuming prettier/prettierd will handle formatting, we don't need to see these errors
      rulesCustomizations = {
        { rule = "prettier/prettier", severity = "off" },
      },
      format = false,
    },
  },
  emmet_language_server = {},
  gdscript = {},
  helm_ls = {
    filetypes = { "yaml", "helm", "yaml.helm-values" },
  },
  hls = { filetypes = { "haskell", "lhaskell", "cabal" } },
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  lua_ls = {},
  -- marksman = {},
  nixd = {},
  pyright = {},
  -- tsserver = {},
  svelte = {
    plugin = {
      svelte = {
        defaultScriptLanguage = "ts",
      },
    },
  },
  tailwindcss = {},
  -- vtsls = {},
  ts_ls = {},
  -- vtsls = {
  --   maxTsServerMemory = 16384,
  --   filetypes = {
  --     "javascript",
  --     "javascriptreact",
  --     "javascript.jsx",
  --     "typescript",
  --     "typescriptreact",
  --     "typescript.tsx",
  --   },
  --   settings = {
  --     complete_function_calls = true,
  --     vtsls = {
  --       enableMoveToFileCodeAction = true,
  --       autoUseWorkspaceTsdk = true,
  --       experimental = {
  --         completion = {
  --           enableServerSideFuzzyMatch = true,
  --         },
  --       },
  --     },
  --     typescript = {
  --       updateImportsOnFileMove = { enabled = "always" },
  --       suggest = {
  --         completeFunctionCalls = true,
  --       },
  --       inlayHints = {
  --         enumMemberValues = { enabled = true },
  --         functionLikeReturnTypes = { enabled = true },
  --         parameterNames = { enabled = "literals" },
  --         parameterTypes = { enabled = true },
  --         propertyDeclarationTypes = { enabled = true },
  --         variableTypes = { enabled = false },
  --       },
  --     },
  --   },
  -- },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
}

for server, config in pairs(servers) do
  config.capabilities = capabilities
  lspconfig[server].setup(config)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(e)
    local opts = { buffer = e.bufnr }
    local set = vim.keymap.set
    local lsp_buf = vim.lsp.buf
    set("n", "gD", lsp_buf.declaration, opts)
    set("n", "gd", lsp_buf.definition, opts)
    set("n", "K", lsp_buf.hover, opts)
    set("n", "gi", lsp_buf.implementation, opts)
    set("n", "<C-k>", lsp_buf.signature_help, opts)
    set("n", "<space>wa", lsp_buf.add_workspace_folder, opts)
    set("n", "<space>wr", lsp_buf.remove_workspace_folder, opts)
    set("n", "<space>wl", function()
      print(vim.inspect(lsp_buf.list_workspace_folders()))
    end, opts)
    set("n", "<space>D", lsp_buf.type_definition, opts)
    set("n", "<space>rn", lsp_buf.rename, opts)
    set({ "n", "v" }, "<space>ca", lsp_buf.code_action, opts)
    set("n", "gr", lsp_buf.references, opts)

    -- Taken from https://blog.viktomas.com/graph/neovim-lsp-rename-normal-mode-keymaps/
    set("n", "<leader>r", vim.lsp.buf.rename)
    -- function()
    --   -- Automatically switch to `cmdwin` for normal mode renaming
    --   -- (normally you would have to press <C-f> to open the `cmdwin`)
    --   vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
    --     callback = function()
    --       local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
    --       vim.api.nvim_feedkeys(key, "c", false)
    --       vim.api.nvim_feedkeys("0", "n", false)
    --       return true
    --     end,
    --   })
    --   vim.lsp.buf.rename()
    -- end, bufoptsWithDesc("Rename symbol")
    -- )
  end,
})
