vim.cmd([[
fu! Compile()
  if expand('%:e') == "md" 
    :silent exec "!pandoc % -s -o /tmp/op.pdf &"
  endif
endfu

fu! Preview()
  :call Compile()
  :silent exec "!zathura /tmp/op.pdf &"
endfu
]])
