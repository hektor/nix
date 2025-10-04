#!/usr/bin/env bash

# Redirect both stdout and stderr to notify-send as is, but set
# urgency to critical if the command fails
output="$(task rc.hooks=0 sync 2>&1)"
ret=$?
if [ $ret -ne 0 ]; then
  urgency=critical
else
  urgency=normal
fi
notify-send -u $urgency "Taskwarrior sync" "$output"
