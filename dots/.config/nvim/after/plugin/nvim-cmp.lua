local cmp = require("cmp")
local luasnip = require("luasnip")

-- TODO: Fix command mode completion (should behave similar to insert mode)

local c_j = cmp.mapping(function()
  if cmp.visible() then
    cmp.select_next_item()
  else
    cmp.complete()
    cmp.select_next_item()
  end
end, { "i", "s" })

local c_k = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    -- NOTE: Keep <C-k> fallback for digraphs
    -- ```lua
    -- cmp.complete()
    -- cmp.select_prev_item()
    -- ```
    fallback()
  end
end, { "i", "s" })

local c_h = cmp.mapping(function(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end, { "i", "s" })

local c_l = cmp.mapping(function(fallback)
  if cmp.visible() and cmp.get_active_entry() then
    cmp.confirm()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end, { "i", "s" })

cmp.setup({
  completion = {
    autocomplete = false,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  -- See `:h luasnip` for the commands
  -- Note: have not added choice note mappings yet
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = c_j,
    ["<C-k>"] = c_k,
    ["<C-h>"] = c_h,
    ["<C-l>"] = c_l,
    ["<CR>"] = c_l,
  }),
  sources = {
    { name = "copilot",  group_index = 2 },
    { name = "nvim_lsp", keyword_length = 8 },
    { name = "luasnip",  max_item_count = 16 },
    { name = "path" },
    { name = "buffer",   max_item_count = 8 },
  },
  window = {
    completion = cmp.config.window.bordered({ border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" } }),
    documentation = cmp.config.window.bordered({ border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" } }),
  },
  formatting = {
    fields = {
      "abbr",
      "menu",
      "kind",
    },
    format = function(entry, item)
      -- Rename kind to shorthand
      item.menu = ({
        nvim_lsp = "[lsp]",
        luasnip = "[snip]",
        path = "[path]",
        buffer = "[buf]",
      })[entry.source.name]

      return item
    end,
    expandable_indicator = true,
  },
})
