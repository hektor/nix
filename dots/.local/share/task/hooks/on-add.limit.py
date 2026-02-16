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

slots = get_slots()

if slots <= 0:
    print(f"Cannot add task: No slots available (0/{slots}).")
    print("Delete or complete a task first to earn an add slot.")
    sys.exit(1)

with open(SLOTS_FILE, "w") as f:
    f.write(str(slots - 1))

print(f"Task added. Slots remaining: {slots - 1}")

for line in sys.stdin:
    task = json.loads(line)
    print(json.dumps(task))
    sys.exit(0)
