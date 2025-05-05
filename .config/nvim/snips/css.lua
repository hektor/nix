local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Flex
  s({ trig = "b1", dscr = "Add 'border: 1px <color>;'" }, {
    t("border: 1px solid "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "dfl", dscr = "Add 'display: flex;'" }, {
    t("display: flex;"),
    i(0),
  }),
  s({ trig = "flr", dscr = "Add 'flex-direction: row;'" }, {
    t("flex-direction: row;"),
    i(0),
  }),
  s({ trig = "flc", dscr = "Add 'flex-direction: column;'" }, {
    t("flex-direction: column;"),
    i(0),
  }),
  s({ trig = "flw", dscr = "Add 'flex-wrap: wrap;'" }, {
    t("flex-wrap: wrap;"),
    i(0),
  }),
  s({ trig = "dfc", dscr = "Display flex column" }, {
    t("display: flex;"),
    t("flex-direction: column;"),
    i(0),
  }),
  -- Grid
  s({ trig = "dg", dscr = "Add 'display: grid;'" }, {
    t("display: grid;"),
    i(0),
  }),
  -- Block
  s({ trig = "db", dscr = "Add 'display: block;'" }, {
    t("display: block;"),
    i(0),
  }),
  -- None
  s({ trig = "dn", dscr = "Add 'display: none;'" }, {
    t("display: none;"),
    i(0),
  }),
  -- CSS Variables
  s({ trig = "v", dscr = "Add CSS variable" }, {
    t("var(--"),
    i(1),
    t(")"),
    i(0),
  }),
  -- Margin
  s({ trig = "m", dscr = "Add 'margin: ;'" }, {
    t("margin: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "mt", dscr = "Add 'margin-top: ;'" }, {
    t("margin-top: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "mr", dscr = "Add 'margin-right: ;'" }, {
    t("margin-right: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "mb", dscr = "Add 'margin-bottom: ;'" }, {
    t("margin-bottom: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "ml", dscr = "Add 'margin-left: ;'" }, {
    t("margin-left: "),
    i(1),
    t(";"),
    i(0),
  }),
  -- Padding
  s({ trig = "p", dscr = "Add 'padding: ;'" }, {
    t("padding: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "pt", dscr = "Add 'padding-top: ;'" }, {
    t("padding-top: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "pr", dscr = "Add 'padding-right: ;'" }, {
    t("padding-right: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "pb", dscr = "Add 'padding-bottom: ;'" }, {
    t("padding-bottom: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "pl", dscr = "Add 'padding-left: ;'" }, {
    t("padding-left: "),
    i(1),
    t(";"),
    i(0),
  }),
}
