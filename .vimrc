source .vim/init/base.vim
source .vim/init/mappings.vim

if !exists('g:vscode')
  source .vim/init/plugins.vim
  source .vim/init/colors.vim
endif
