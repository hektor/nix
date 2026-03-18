local map = vim.keymap.set

require("keymaps")

map({ "n", "v" }, "<leader>p", '<cmd>call VSCodeNotify("workbench.action.quickOpen")<cr>')
map({ "n", "v" }, "<leader>f", '<cmd>call VSCodeNotify("workbench.action.findInFiles")<cr>')
map({ "n", "v" }, "<leader>b", '<cmd>call VSCodeNotify("workbench.action.toggleSidebarVisibility")<cr>')
map({ "n", "v" }, "<leader>t", '<cmd>call VSCodeNotify("workbench.action.togglePanel")<cr>')
map({ "n", "v" }, "<leader>ca", "<cmd>call VSCodeNotify('editor.action.quickFix')<cr>")
