# `deploy` wrapper script that opens a short-lived SSH master process for
# `deploy-rs` to use so it works with hardware-backed key touch+PIN. assumes
# ControlPath ~/.ssh/control/%C (see ../ssh/default.nix)

# extract the target host from the `deploy-rs` flake target (e.g. `.#hecuba`)
node=""
for arg in "$@"; do
  case "$arg" in
    -*) ;;
    *'#'*)
      node="${arg#*#}"   # strip flake ref up to '#'
      node="${node%%@*}" # strip '@user'
      node="${node%%.*}" # strip '.profile'
      ;;
  esac
done

master=0
if [[ -n "$node" ]] && ! ssh -O check "$node" 2>/dev/null; then
  # place ssh client into "master" mode for connection sharing (see `man ssh`)
  if ssh -fNM "$node"; then
    master=1
  fi
fi

rc=0
@deploy@ "$@" || rc=$?

# request the master process to exit (see `man ssh`)
if ((master)); then
  ssh -O exit "$node" 2>/dev/null || true
fi

exit "$rc"
