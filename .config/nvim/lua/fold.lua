vim.cmd([[
" Folds {{{
set foldmethod=marker

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal foldmethod=indent
augroup END

augroup filetype_sh
    autocmd!
    autocmd FileType sh setlocal foldmethod=marker
augroup END

augroup filetype_snippets
    autocmd!
    autocmd FileType snippets setlocal foldmethod=marker
augroup END

" }}}
]])
