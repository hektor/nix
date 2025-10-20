vim.cmd([[
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
autocmd BufEnter *.md if expand('%:t') =~ '--' | echo 'relation' | endif
autocmd BufEnter *.md if expand('%:t') =~ '<>' | echo 'dichotomy' | endif
autocmd BufEnter *.md if expand('%:t') =~ 'my-' | echo 'personal file' | endif
autocmd BufEnter *.md if expand('%:t') =~ 'project_' | echo 'project file' | endif

" Only load wiki.vim for zk directory
let g:wiki_index_name='index'

" Links
let g:wiki_link_extension=''
" Do not automatically transform to link, use `<leader>wf` for this
let g:wiki_link_target_type='md'

vmap <leader>wf <plug>(wiki-link-toggle-visual)

"
" Links
"

"
" Options
"

"
" Events
"

"
" Mappings and commands
"

"
" Completion
"

let g:wiki_completion_enabled=1
let g:wiki_completion_case_sensitive=0

"
" Tags
"

"
" Templates
"

let g:wiki_templates = [
      \ { 'match_re': '^my-',
      \   'source_filename': '.my.md'},
      \ { 'match_re': '^project[-_]',
      \   'source_filename': '.project.md'},
      \ { 'match_re': '^blog[-_]',
      \   'source_filename': '.blog.md'},
      \ { 'match_re': '^journal[-_]',
      \   'source_filename': '.journal.md'},
      \ { 'match_func': { x -> v:true },
      \   'source_filename': '.md'},
      \]

"
" Advanced configuration
"

let g:wiki_filetypes=['md']
let g:wiki_root='~/.zk'
let g:wiki_global_load=0
let g:wiki_link_creation = {
      \ 'md': {
      \   'link_type': 'md',
      \   'url_extension': '',
      \   'url_transform': { x -> substitute(tolower(x), '\s\+', '-', 'g') },
      \ },
      \ '_': {
      \   'link_type': 'wiki',
      \   'url_extension': '',
      \ },
      \}

" let g:wiki_link_default_schemes
" let g:wiki_link_schemes
let g:wiki_link_toggle_on_follow=0
" let g:wiki_link_transforms
" let g:wiki_mappings_use_defaults
" let g:wiki_mappings_global
" let g:wiki_mappings_local
" let g:wiki_mappings_local_journal
" ... tags
" let g:wiki_template_month_names
" let g:wiki_template_title_month = 
" let g:wiki_template_title_week
" let g:wiki_ui_method
let g:wiki_write_on_nav=1
let g:wiki_zotero_root='~/.local/share/zotero'
" ... mappings and commands
" ...
]])
