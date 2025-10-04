let s:zk_preview_enabled = 0
let s:live_server_job = -1
au BufEnter /home/h/.zk/*.md silent exe '!echo "%" > /home/h/.zk/current-zettel.txt'
function! ToggleZKPreview()
    if s:zk_preview_enabled == 1
        let s:zk_preview_enabled = 0
        call jobstop(s:live_server_job)
        au! ZKPreview
    else
        let s:zk_preview_enabled = 1
        let s:live_server_job = jobstart('live-server --watch=/home/h/.zk/current-zettel-content.html --open=current-zettel-content.html --port=8080')
        augroup ZKPreview
          au BufEnter /home/h/.zk/*.md silent exe '!cat "%:r.html" > /home/h/.zk/current-zettel-content.html'
          au BufWritePost /home/h/.zk/*.md silent exe '!make && cat "%:r.html" > /home/h/.zk/current-zettel-content.html'
        augroup END
    endif
endfunction
command! ToggleZKPreview call ToggleZKPreview()

nn <leader>o :ToggleZKPreview<cr> :!xdg-open http://localhost:8080/%:t:r.html & <cr>
