" FZF
nn <c-p> :FZF<cr>
nn <leader>p :FZF<cr>
nn <leader>b :Buffers<cr>
nn <leader>h :History<cr>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" Insert path completion
" ino <expr><c-f> fzf#vim#complete#path('ag -l -g *.md')
" ino <c-f> <plug>(fzf-complete-file-ag)
ino <expr><c-f> fzf#vim#complete#path("ag -l -g '' \| sed -e 's/\.md$//'")
" Use `the_silver_searcher` to find results (for selection if selection)
nn <leader>f :Ag<cr>
vm <leader>f :Ag <C-r>"<cr>
