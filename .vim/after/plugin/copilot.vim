let g:copilot_no_tab_map = v:true
imap <c-l> <plug>(copilot-next)
imap <c-h> <plug>(copilot-prev)
imap <silent><script><expr> <s-tab> copilot#Accept("\<CR>")
