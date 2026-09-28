local ls = require("luasnip")

ls.config.set_config({
  history = true,
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
  ext_prio_increase = 1,
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})

require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/.config/nvim/snips" } })
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/Code - Insiders/User/snippets" } })
