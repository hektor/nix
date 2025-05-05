local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

-- Taken from https://ejmastnak.com/tutorials/vim-latex/luasnip/#anatomy
local get_visual = function(_, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

return {
  s(
    { trig = "^h", regTrig = true, dscr = "Markdown header" },
    fmta("# <><>", {
      d(1, get_visual),
      i(0),
    })
  ),
  s(
    { trig = "^sec", regTrig = true, dscr = "Markdown header" },
    fmta("## <><>", {
      d(1, get_visual),
      i(0),
    })
  ),
  s(
    { trig = "^ssec", regTrig = true, dscr = "Markdown header" },
    fmta("### <><>", {
      d(1, get_visual),
      i(0),
    })
  ),
}
