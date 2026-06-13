# `colmena` wrapper script that opens a short-lived SSH master process for
# `colmena` to use so it works with hardware-backed key touch+PIN. assumes
# ControlPath ~/.ssh/socket-%r@%h:%p (see ./default.nix)

selector=""
want_on=0
on_given=0
deploy_cmd=0
nodes=()
on_nodes=()
master_processes=()

# build node list from `--on` value, a comma-separated string (e.g. "host-01,host-02")
for arg in "$@"; do
  if ((want_on)); then
    selector="$arg"
    want_on=0
    continue
  fi
  case "$arg" in
    --on=*)
      selector="${arg#--on=}"
      on_given=1
      ;;
    --on) want_on=1 on_given=1 ;;
    apply | exec | upload-keys) deploy_cmd=1 ;;
  esac
done

# shellcheck disable=SC2154
if ((deploy_cmd)) && ! ((on_given)); then
  on_nodes=("${!_colmena_node_tags[@]}")
else
  IFS=',' read -ra nodes <<< "$selector"
  for node in "${nodes[@]}"; do
    for node_tag in "${!_colmena_node_tags[@]}"; do
      if [[ "$node" == @* ]]; then
        for tag in ${_colmena_node_tags[$node_tag]}; do
          # shellcheck disable=SC2053
          [[ "$tag" == ${node#@} ]] && on_nodes+=("$node_tag")
        done
      else
        # shellcheck disable=SC2053
        [[ "$node_tag" == $node ]] && on_nodes+=("$node_tag")
      fi
    done
  done
fi

for node in "${on_nodes[@]}"; do
  # check if master process is running (see `man ssh`)
  ssh -O check "$node" 2>/dev/null && continue

  # place ssh client into "master" mode for connection sharing (see `man ssh`)
  if ssh -fNM "$node"; then
    master_processes+=("$node")
  fi
done

rc=0
@colmena@ "$@" || rc=$?

# request master processes to exit (see `man ssh`)
for process in "${master_processes[@]}"; do
  ssh -O exit "$process" 2>/dev/null || true
done

exit "$rc"
