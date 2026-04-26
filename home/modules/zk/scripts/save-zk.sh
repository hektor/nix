cd "$ZK_PATH" || { echo "No zettelkasten directory found"; exit 1; }
git add . && git commit -m "Update" && git push
