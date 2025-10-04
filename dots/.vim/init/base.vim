" General config {{{
"
" Tip: acronyms for overview, use `:h` for a quick lookup.

set nocp                               " Disable vi incompatibility
filetype plugin indent on              " Filetype recognition
set enc=utf8                           " Default to UTF-8 encoding
set hid                                " Allow hiding unsaved buffers
set tf                                 " Fast tty
set ut=300                             " 300ms for update time
set to tm=200 ttm=5                    " Timeouts
set shm+=c                             " ...
set ul=500 hi=500                      " History and undo
set nu rnu scl=number                  " Line numbers & signs
set nowrap
set bs=indent,eol,start                " Indentation
set ai ts=2 sts=2 sw=2 et              " Indentation
set is ic scs hls                      " Search
set lz                                 " Only essential redraws
set nobk nowb noswf                    " No backups
set vi='20,\"101                       " Max 100 lines in registers
set novb                               " Bell
set cole=0 cocu=""                     " Conceal
set cb=unnamedplus                     " Clipboard
set fcs+=vert:│                        " Cleaner split separator (tmux style)
set list
set lcs=trail:·,tab:→\ ,nbsp:␣         " Whitespace rendering
set ar                                 " Autoread
set spellsuggest+=5                    " Limit spell suggestions
set wildignore+=*/node_modules/*,*/tmp/*,*.so,*.swp,*.zip
set thesaurus+=~/.vim/thesaurus/mthesaur.txt

" }}}
