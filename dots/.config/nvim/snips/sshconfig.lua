local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("host", {
    t("Host "),
    i(1, "alias"),
    t({ "", "\tHostName " }),
    i(2, "name"),
    t({ "", "\tUser " }),
    i(3, "user"),
  }),
}
