vim.filetype.add({
  filename = {
    [".lintstagedrc"] = "json",
  },
  pattern = {
    [".*/%.vscode/.*%.json"] = "jsonc",
    [".*/%.ssh/config%.d/.*"] = "sshconfig",
  },
})
