local hydra_repl = "hydra-repl"

if not vim.fn.executable(hydra_repl) then
  return
end

local function send(lines)
  vim.system({ hydra_repl, table.concat(lines, "\n") })
end

local function get_paragraph(buf)
  local start_ = vim.fn.search("^$", "bnW")
  local end_ = vim.fn.search("^$", "nW") - 1
  if end_ < vim.api.nvim_win_get_cursor(0)[1] then
    end_ = vim.api.nvim_buf_line_count(buf)
  end
  return vim.api.nvim_buf_get_lines(buf, start_, end_, false)
end

local function get_selection(buf)
  return vim.api.nvim_buf_get_lines(buf, vim.fn.line("'<") - 1, vim.fn.line("'>"), false)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function(e)
    if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(e.buf), ":e") ~= "hydra" then
      return
    end

    local buf = e.buf
    vim.keymap.set("n", "<CR>", function() send(get_paragraph(buf)) end, { buffer = buf, desc = "hydra: send block" })
    vim.keymap.set("v", "<CR>", function() send(get_selection(buf)) end, { buffer = buf, desc = "hydra: send selection" })
  end,
})
