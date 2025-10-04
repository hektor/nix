#!/usr/bin/env python3

# Source: <https://gist.github.com/danmou/83079feac22307813178d7f8c456c544>

# This hooks script syncs task warrior to the configured task server without blocking.
# The on-exit event is triggered once, after all processing is complete.

# Make sure hooks are enabled and this hook script is executable.
# Run `task diag` for diagnostics on the hook.

import json
import subprocess
import sys

try:
    tasks = json.loads(sys.stdin.readline())
except:
    # No input
    pass

# Call the `sync` command
# hooks=0 ensures that the sync command doesn't call the on-exit hook
# verbose=nothing sets the verbosity to print nothing at all

ps_1 = subprocess.Popen(
    ["task", "rc.hooks=0", "sync"],
    stdin=subprocess.PIPE,
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL,
)

sys.exit(0)
