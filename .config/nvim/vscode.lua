local cmd = vim.cmd
local bind = vim.keymap.set

cmd([[
source ~/.vim/init/base.vim
source ~/.vim/init/mappings.vim
]])

require("keymaps")

bind('n', '<leader>p', '<cmd>call VSCodeNotify("workbench.action.quickOpen")<cr>')
bind('n', '<leader>f', '<cmd>call VSCodeNotify("workbench.action.findInFiles")<cr>')
bind('n', '<leader>b', '<cmd>call VSCodeNotify("workbench.action.toggleSidebarVisibility")<cr>')
bind('n', '<leader>t', '<cmd>call VSCodeNotify("workbench.action.togglePanel")<cr>')
