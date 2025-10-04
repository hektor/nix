" Paste clipboard images
au FileType pandoc nmap <buffer><silent> <leader>v :call mdip#MarkdownClipboardImage()<CR>
au FileType markdown nmap <buffer><silent> <leader>v :call mdip#MarkdownClipboardImage()<CR>
