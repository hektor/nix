if [ ! -d "$ZK_PATH" ]; then
  echo "[zk] Setting up zettelkasten"
  gh repo clone zk "$ZK_PATH"
fi

if [ -f "$ZK_PATH/current-zettel.txt" ]; then
  target="$(cat "$ZK_PATH/current-zettel.txt")"
else
  target="."
fi

if [ -n "${TMUX:-}" ]; then
  cd "$ZK_PATH" && $EDITOR "$target"
else
  echo 'Not in tmux'
  echo 'Choose an option:'
  echo '1. Open in tmux'
  echo '2. Open in current terminal'
  read -r -p 'Enter your choice: ' choice
  case $choice in
    1)
      if tmux has-session -t zk 2>/dev/null; then
        tmux attach -t zk
      else
        tmux new-session -s zk -n zk -d
        tmux send-keys -t zk:zk "cd ${ZK_PATH} && $EDITOR ${target}" Enter
        tmux attach -t zk
      fi
      ;;
    2)
      cd "$ZK_PATH" && $EDITOR "$target"
      ;;
    *)
      echo 'Not opening Zettelkasten'
      exit 1
      ;;
  esac
fi
