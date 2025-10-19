local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

-- Inspired by https://castel.dev/post/lecture-notes-1/

ls.add_snippets("tex", {
  s("beg", {
    t("\\begin{"),
    i(1),
    t({ "}", "\t" }),
    i(0),
    t({ "", "\\end{" }),
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t("}"),
  }),

  s("def", {
    t("\\begin{definition}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{definition}" }),
  }),

  s("fig", {
    t("\\begin{figure}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{figure}" }),
  }),

  s(
    "time",
    f(function()
      return os.date("%H:%M")
    end)
  ),

  s("i", t("\\textit{"), i(0), t("}")),

  s("b", t("\\textbf{"), i(0), t("}")),

  s("center", {
    t("\\begin{center}"),
    t({ "", "" }),
    i(0),
    t({ "", "\\end{center}" }),
  }),

  s("pac", t("\\usepackage{"), i(0), t("}")),

  s("foot", t("\\footnote{"), i(0), t("}")),

  s("dm", {
    t({ "\\[", "" }),
    i(1),
    t({ "", "\\]" }),
    i(0),
  }),

  s("ch", t("\\chapter{"), i(0), t("}")),
  s("sec", t("\\section{"), i(0), t("}")),
  s("ssec", t("\\subsection{"), i(0), t("}")),
  s("sssec", t("\\subsubsection{"), i(0), t("}")),
})
