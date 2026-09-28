vim.g.tidal_default_config = { socket_name = "default", target_pane = "tidal:1.1" }
vim.g.tidal_no_mappings = 1

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tidal",
  callback = function(e)
    local buf = e.buf
    vim.keymap.set("n", "<leader>ep", "<Plug>TidalParagraphSend", { buffer = buf, desc = "Tidal: send paragraph" })
    vim.keymap.set("n", "<leader>ee", "<Plug>TidalLineSend", { buffer = buf, desc = "Tidal: send line" })
    vim.keymap.set("n", "<leader>h", ":TidalHush<cr>", { buffer = buf, desc = "Tidal: hush" })
    vim.api.nvim_buf_create_user_command(buf, "S", "TidalSilence <args>", { nargs = 1 })
    vim.api.nvim_buf_create_user_command(buf, "P", "TidalPlay <args>", { nargs = 1 })
    vim.api.nvim_buf_create_user_command(buf, "H", "TidalHush", { nargs = 0 })
  end,
})

-- SuperCollider
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNewFile", "BufRead" }, {
  pattern = { "*.sc", "*.scd" },
  callback = function()
    vim.bo.filetype = "supercollider"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "supercollider",
  command = "packadd scvim",
})
