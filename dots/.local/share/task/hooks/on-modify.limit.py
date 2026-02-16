#!/usr/bin/env python3
import sys
import json

SLOTS_FILE = "/home/h/.local/share/task/add_slots"

def get_slots():
    try:
        with open(SLOTS_FILE, "r") as f:
            return int(f.read().strip())
    except:
        return 0

data = sys.stdin.read().strip().split("\n")
if len(data) < 2:
    for line in data:
        if line:
            print(line)
    sys.exit(0)

old_task = json.loads(data[0])
new_task = json.loads(data[1])

was_pending = old_task.get("status") == "pending"
is_not_pending = new_task.get("status") in ("completed", "deleted")

if was_pending and is_not_pending:
    slots = get_slots() + 1
    with open(SLOTS_FILE, "w") as f:
        f.write(str(slots))
    print(f"Slot earned! Total slots: {slots}")

print(json.dumps(new_task))
sys.exit(0)
