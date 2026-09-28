local autocmd = vim.api.nvim_create_autocmd

autocmd("BufNewFile", {
  pattern = "shell.nix",
  command = "0r ~/.config/nvim/skeletons/shell.nix.skeleton",
})

autocmd("BufNewFile", {
  pattern = "flake.nix",
  command = "0r ~/.config/nvim/skeletons/flake.nix.skeleton",
})
