local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({ trig = "ifdef" }, {
    t("#ifdef GL_ES"),
    t("precision mediump float;"),
    i(1),
    t("#endif"),
  }),
  s({ trig = "defpi" }, {
    t("#define PI 3.14159265359"),
  }),
  s({ trig = "main" }, {
    t("void main() {"),
    i(1),
    t("}"),
  }),
  s({ trig = "uni" }, {
    t("uniform "),
    i(1),
    t(";"),
  }),
  s({ trig = "unif" }, {
    t("uniform float "),
    i(1),
    t(";"),
  }),
  s({ trig = "univ" }, {
    t("uniform vec"),
    i(1),
    t(" float "),
    i(2),
    t(";"),
  }),
  s({ trig = "univ2" }, {
    t("uniform vec2 float "),
    i(1),
    t(";"),
  }),
  s({ trig = "univ3" }, {
    t("uniform vec3 float "),
    i(1),
    t(";"),
  }),
  s({ trig = "univ4" }, {
    t("uniform vec4 float "),
    i(1),
    t(";"),
  }),
  s({ trig = "f" }, {
    t("float "),
    i(1),
    t(";"),
  }),
  s({ trig = "v" }, {
    t("vec"),
  }),
  s({ trig = "ss" }, {
    t("smoothstep("),
    i(1),
    t(")"),
    i(2),
  }),
}
