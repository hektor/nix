vim.filetype.add({
  filename = {
    [".lintstagedrc"] = "json",
  },
  pattern = {
    [".*/%.ssh/config%.d/.*"] = "sshconfig",
  },
})
