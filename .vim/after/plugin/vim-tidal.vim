" Tidalcycles (sclang and vim-tidal)
let g:tidal_default_config = {"socket_name": "default", "target_pane": "tidal:1.1"}
let g:tidal_no_mappings = 1

au FileType tidal nm <buffer> <leader>ep <Plug>TidalParagraphSend
au FileType tidal nm <buffer> <leader>ee <Plug>TidalLineSend
au FileType tidal nnoremap <buffer> <leader>h :TidalHush<cr>
au FileType tidal com! -nargs=1 S :TidalSilence <args>
au FileType tidal com! -nargs=1 P :TidalPlay <args>
au FileType tidal com! -nargs=0 H :TidalHush

" SuperCollider
au BufEnter,BufWinEnter,BufNewFile,BufRead *.sc,*.scd se filetype=supercollider
au Filetype supercollider packadd scvim
