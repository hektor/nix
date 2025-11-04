vim.filetype.add({
  filename = {
    [".lintstagedrc"] = "json",
  },
  pattern = {
    ["tsconfig.*.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
    [".*/%.ssh/config%.d/.*"] = "sshconfig",
    ["%.env.*"] = "dotenv",
    ["%.pl$"] = "prolog",
    [".*.containerfile.*"] = "dockerfile",
  },
})
