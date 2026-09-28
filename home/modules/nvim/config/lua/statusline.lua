vim.opt.laststatus = 3

vim.cmd([[
se stl=\ %0*%n
se stl+=\ %m
se stl+=\ %y%0*
se stl+=\ %<%F
se stl+=\ %0*%=%5l%*
se stl+=%0*/%L%*
]])
