local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("reqtrace", t({ "(#%require racket/trace)" })),
  s("strln", t({ "(string-length " }), i(1), t({ ")" })),
  s("impb", t({ "(import (rnrs base (6))", "        (rnrs io simple" }), i(0), t({ ")" })),
  s("def", {
    t("(define "),
    i(1),
    t(" "),
    i(2),
    t(")"),
  }),
  s("defp", {
    t("(define ("),
    i(1),
    t(" "),
    i(2),
    t("))"),
  }),
}
