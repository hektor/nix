augroup Vim
  au!
  " Reload vim config when ~/.vimrc is changed
  au BufWritePost $HOME/.vimrc so $MYVIMRC | redraw | echo "Reloaded vimrc"
augroup END
