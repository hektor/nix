local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Flex
  s({ trig = "b1", desc = "Add 'border: 1px <color>;'" }, {
    t("border: 1px solid "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "dfl", desc = "Add 'display: flex;'" }, {
    t("display: flex;"),
    i(0),
  }),
  s({ trig = "flr", desc = "Add 'flex-direction: row;'" }, {
    t("flex-direction: row;"),
    i(0),
  }),
  s({ trig = "flc", desc = "Add 'flex-direction: column;'" }, {
    t("flex-direction: column;"),
    i(0),
  }),
  s({ trig = "flw", desc = "Add 'flex-wrap: wrap;'" }, {
    t("flex-wrap: wrap;"),
    i(0),
  }),
  s({ trig = "dfc", desc = "Add 'flex-direction: column;'" }, {
    t("display: flex;"),
    t("flex-direction: column;"),
    i(0),
  }),
  -- Grid
  s({ trig = "dg", desc = "Add 'display: grid;'" }, {
    t("display: grid;"),
    i(0),
  }),
  -- Block
  s({ trig = "db", desc = "Add 'display: block;'" }, {
    t("display: block;"),
    i(0),
  }),
  -- None
  s({ trig = "dn", desc = "Add 'display: none;'" }, {
    t("display: none;"),
    i(0),
  }),
  -- CSS Variables
  s({ trig = "v", desc = "Add CSS variable" }, {
    t("var(--"),
    i(1),
    t(")"),
    i(0),
  }),
  -- Margin
  s({ trig = "m", desc = "Add 'margin: ;'" }, {
    t("margin: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "mt", desc = "Add 'margin-top: ;'" }, {
    t("margin-top: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "mr", desc = "Add 'margin-right: ;'" }, {
    t("margin-right: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "mb", desc = "Add 'margin-bottom: ;'" }, {
    t("margin-bottom: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "ml", desc = "Add 'margin-left: ;'" }, {
    t("margin-left: "),
    i(1),
    t(";"),
    i(0),
  }),
  -- Padding
  s({ trig = "p", desc = "Add 'padding: ;'" }, {
    t("padding: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "pt", desc = "Add 'padding-top: ;'" }, {
    t("padding-top: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "pr", desc = "Add 'padding-right: ;'" }, {
    t("padding-right: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "pb", desc = "Add 'padding-bottom: ;'" }, {
    t("padding-bottom: "),
    i(1),
    t(";"),
    i(0),
  }),
  s({ trig = "pl", desc = "Add 'padding-left: ;'" }, {
    t("padding-left: "),
    i(1),
    t(";"),
    i(0),
  }),
}
