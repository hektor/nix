local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({ trig = "clg", desc = "console.log" }, {
    t("console.log("),
    i(1),
    t(")"),
    i(0),
  }),
  s({ trig = "Js", desc = "JSON.stringify" }, {
    t("JSON.stringify("),
    i(1),
    t(")"),
    i(0),
  }),
  s({ trig = "Jsf", desc = "JSON.stringify (formatted)" }, {
    t("JSON.stringify("),
    i(1),
    t(", 0, 2)"),
    i(0),
  }),
}
