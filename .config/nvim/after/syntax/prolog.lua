vim.cmd([[
syn keyword Operator \+ conceal cchar=¬
syn keyword Operator ,  conceal cchar=∧
syn keyword Operator ;  conceal cchar=∨
]])

vim.cmd.runtime("syntax/_comment_keywords.lua")
