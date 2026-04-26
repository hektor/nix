require("zk.cmp")
require("zk.utils")

vim.cmd([[
let s:zk_preview_enabled = 0
let s:live_server_job = -1
execute 'au BufEnter' g:zk_path . '/*.md' 'silent exe "!echo %" ">" g:zk_path . "/current-zettel.txt"'
function! ToggleZKPreview()
    if s:zk_preview_enabled == 1
        let s:zk_preview_enabled = 0
        call jobstop(s:live_server_job)
        au! ZKPreview
    else
        let s:zk_preview_enabled = 1
        let s:live_server_job = jobstart('live-server --watch=' . g:zk_path . '/current-zettel-content.html --open=current-zettel-content.html --port=8080')
        augroup ZKPreview
          execute 'au BufEnter' g:zk_path . '/*.md' 'silent exe "!cat %:r.html" ">" g:zk_path . "/current-zettel-content.html"'
          execute 'au BufWritePost' g:zk_path . '/*.md' 'silent exe "!make && cat %:r.html" ">" g:zk_path . "/current-zettel-content.html"'
        augroup END
    endif
endfunction
command! ToggleZKPreview call ToggleZKPreview()

nn <leader>o :ToggleZKPreview<cr> :!xdg-open http://localhost:8080/%:t:r.html & <cr>
]])
