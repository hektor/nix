-- NOTE: May want to move this, as it is more specific to wiki than to pandoc
vim.api.nvim_create_user_command("AnkiDeck", function()
  local handle = io.popen("get-anki-decks")
  local decks = {}
  for line in handle:lines() do
    table.insert(decks, line)
  end
  handle:close()

  vim.ui.select(decks, { prompt = "Select Anki deck" }, function(choice)
    if choice then
      vim.api.nvim_put({ choice }, "", true, true)
    end
  end)
end, {})

vim.cmd([[
set cc=81
set cocu=""
func! GetContext()
  " https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
  if !exists("*synstack")
    return
  endif
  let matches = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  if index(matches, 'pandocLaTeXInlineMath') >= 0
    echo 'math_inline'
  elseif index(matches, 'pandocLaTeXMathBlock') >= 0
    echo 'math_block'
  elseif !empty(matches)
    echo matches[0]
  else
    echo ''
  endif
endfunc
com! -nargs=0 GetContext :call GetContext()
]])
