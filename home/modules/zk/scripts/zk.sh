current_zettel_path="$(cat "$ZK_PATH/current-zettel.txt")"

if [ -n "${TMUX:-}" ]; then
  cd "$ZK_PATH" && $EDITOR "$current_zettel_path"
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
        tmux send-keys -t zk:zk "cd $ZK_PATH && $EDITOR $current_zettel_path" Enter
        tmux attach -t zk
      fi
      ;;
    2)
      cd "$ZK_PATH" && $EDITOR "$current_zettel_path"
      ;;
    *)
      echo 'Not opening Zettelkasten'
      exit 1
      ;;
  esac
fi
