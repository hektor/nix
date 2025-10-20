vim.cmd([[
let g:pandoc#syntax#conceal#urls=1
let g:pandoc#syntax#codeblocks#embeds#langs=[
  \ 'python',
  \ 'bash',
  \ 'javascript',
  \ 'typescript',
  \ 'html',
  \ 'css',
  \ 'scss',
  \ 'json',
  \ 'yaml'
  \ ]
let g:pandoc#syntax#style#emphases=0 " Bug workaround
let g:pandoc#syntax#conceal#cchar_overrides = { "atx": " ", "li": "·" }
let g:pandoc#syntax#conceal#blacklist=[]
]])
