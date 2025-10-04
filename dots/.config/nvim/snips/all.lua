local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

local TM_FILENAME = function(_, snip)
  return snip.env.TM_FILENAME
end

local TM_FILENAME_BASE = function(_, snip)
  return snip.env.TM_FILENAME_BASE
end

local NAME = "Hektor Misplon"
local LOCALHOST = "localhost"
local LOCALHOST_IP = "127.0.0.1"

return {
  s({ trig = "fn", desc = "Filename" }, { f(TM_FILENAME_BASE) }),
  s({ trig = "fne", dscr = "Filename (+extension)" }, { f(TM_FILENAME) }),
  s({ trig = "hm" }, { t(NAME) }),
  s({ trig = "loho" }, { t(LOCALHOST) }),
  s({ trig = "lohoi" }, { t(LOCALHOST_IP) }),
  s({ trig = "date" }, { f(function()
    return os.date("%Y-%m-%d")
  end) }),
}
