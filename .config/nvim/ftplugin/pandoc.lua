-- NOTE: May want to move this, as it is more specific to wiki than to pandoc
vim.api.nvim_create_user_command("AnkiDeck", function()
  local handle = io.popen("get-anki-decks")
  local decks = {}
  for line in handle:lines() do
    table.insert(decks, line)
  end
  handle:close()

  vim.ui.select(decks, { prompt = "Select Anki deck" }, function(choice)
    if choice then
      vim.api.nvim_put({ choice }, "", true, true)
    end
  end)
end, {})
