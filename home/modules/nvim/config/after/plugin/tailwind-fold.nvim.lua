if not require("nixCatsUtils").enableForCategory("languages.tailwind") then
  return
end

require("tailwind-fold").setup({ ft = { "html", "svelte", "typescriptreact" } })
