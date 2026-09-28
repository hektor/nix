local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- TODO: extends html, javascript, css

return {
  s("oM", {
    t({ "onMount(() => {" }),
    i(0),
    t({ "})" }),
  }),
  s("oD", {
    t({ "onDestroy(() => {" }),
    i(0),
    t({ "})" }),
  }),
  s("preJsf", {
    t({ "<pre>" }),
    i(0),
    t({ "{JSON.stringify($0, 0, 2)}" }),
    t({ "</pre>" }),
  }),
  s(":g", {
    t({ ":global(" }),
    i(0),
    t({ ")" }),
  }),
}
