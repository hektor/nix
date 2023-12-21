au FileType pandoc call pandoc#completion#Init()
let g:pandoc#filetypes#pandoc_markdown=0
let g:pandoc#spell#enabled=0
let g:pandoc#spell#default_langs=['en_us', 'nl_be']
let g:pandoc#formatting#mode='a'
let g:pandoc#formatting#textwidth=90
let g:pandoc#modules#disabled = ["formatting", "dashes", "yaml", "metadata"]
