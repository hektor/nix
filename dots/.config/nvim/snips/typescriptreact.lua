local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("preJ", {
    t("<pre>{JSON.stringify("),
    i(1, "object"), -- first tab stop
    t(", null, 2)}</pre>"),
  }),
}
