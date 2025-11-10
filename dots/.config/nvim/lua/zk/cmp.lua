local cmp = require("cmp")

local source = {}

local function get_markdown_files(base)
  local items = {}
  local pattern = base .. "/**/*.md"
  local files = vim.fn.glob(pattern, false, true)
  for _, file in ipairs(files) do
    local label = file:gsub("^%./", ""):gsub("%.md$", "")
    table.insert(items, { label = label })
  end
  return items
end

function source:complete(params, callback)
  local cursor_before_line = params.context.cursor_before_line
  local cursor_after_line = params.context.cursor_after_line or ""

  local trigger = cursor_before_line:match("%[[^%]]*%]%(([^)]*)$")

  if trigger ~= nil then
    local items = get_markdown_files(".")
    local next_char = cursor_after_line:sub(1, 1)

    for _, item in ipairs(items) do
      if next_char == ")" then
        item.insertText = item.label
      else
        item.insertText = item.label .. ")"
      end
    end

    callback(items)
  else
    callback({})
  end
end

function source:get_trigger_characters()
  return { "(" }
end

function source:is_available()
  local ft = vim.bo.filetype
  return ft == "markdown" or ft == "pandoc"
end

cmp.register_source("zk", source)
