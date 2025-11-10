local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({ trig = "^M.", regTrig = true, snippetType = "autosnippet" }, {
    t("local M = {"),
    i(1),
    t({ "}", "", "", "return M" }),
  }),
}
