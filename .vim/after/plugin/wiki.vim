" Change local buffer to directory of current file after the plugin has loaded
autocmd VimEnter * lcd %:p:h

" " Override wiki index mapping to also cd into the wiki
nm <leader>ww <plug>(wiki-index)
" nm <leader>l <plug>(wiki-next-link)
" nm <leader>h <plug>(wiki-prev-link)
" nm <leader>j <plug>(wiki-link-follow)
" nm <leader>k <plug>(wiki-link-return)
" nm <leader>s <plug>(wiki-link-follow-split)
" nm <leader>v <plug>(wiki-link-follow-vsplit)

autocmd BufEnter *.md if expand('%:t') =~ '_' | echo 'hierarchical relation' | endif
autocmd BufEnter *.md if expand('%:t') =~ '--' | echo 'non-hierarchical relation' | endif
autocmd BufEnter *.md if expand('%:t') =~ '<>' | echo 'dichotomy' | endif
autocmd BufEnter *.md if expand('%:t') =~ 'my-' | echo 'personal file' | endif
autocmd BufEnter *.md if expand('%:t') =~ 'project-' | echo 'project file' | endif
autocmd BufEnter *.md if expand('%:t') =~ 'project_' | echo 'project file' | endif

" Only load wiki.vim for zk directory
let g:wiki_global_load=0
let g:wiki_root='~/.zk'
let g:wiki_index_name='index'
let g:wiki_zotero_root='~/doc/Zotero'
let g:wiki_filetypes=['md']
let g:wiki_completion_case_sensitive=0

" Links
let g:wiki_link_extension=''
" Do not automatically transform to link, use `<leader>wf` for this
let g:wiki_link_toggle_on_follow=0
let g:wiki_link_target_type='md'

" E.g. transform `My link` into `[My link](my-link.md)`
function Slugify(text) abort
  return [substitute(tolower(a:text), '\s\+', '-', 'g'), a:text]
endfunction

let g:wiki_map_text_to_link='Slugify'

vmap <leader>wf <plug>(wiki-link-toggle-visual)

" Automatically save when navigation
let g:wiki_write_on_nav=1
