local json_newline = function()
  local line = vim.api.nvim_get_current_line()
  if line == "" then
    print("line is empty")
    return "o"
  elseif string.byte(line, -1) == string.byte(",") then
    return "o"
  elseif string.byte(line, -1) == string.byte("{") then
    print("line ends with '{'")
    return "o"
  elseif string.byte(line, -1) == string.byte("}") then
    print("line ends with '}'")
    return "o"
  else
    return "A,<CR>"
  end
end

vim.keymap.set("n", "o", json_newline, { buffer = true, expr = true })
