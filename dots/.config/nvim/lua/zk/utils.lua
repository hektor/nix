vim.g.zk_path = os.getenv("ZK_PATH") or (os.getenv("HOME") .. "/.zk")
return vim.g.zk_path
