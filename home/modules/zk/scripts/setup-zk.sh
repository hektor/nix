if [ ! -d "$ZK_PATH" ]; then
  echo "[zk] Setting up zettelkasten"
  gh repo clone zk "$ZK_PATH"
else
  echo "[zk] Zettelkasten already set up."
fi

read -p "Would you like open your zettelkasten? [y/N] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  $EDITOR "$ZK_PATH"
fi
