#!/bin/bash
# copilot_shell_script.sh
# Updates assignment name in config.env and runs startup.sh

echo "Enter the new assignment name:"
read new_assignment

# Find the environment directory
DIR=$(find . -type d -name "submission_reminder_*" | head -n 1)
CONFIG="$DIR/config/config.env"

if [ ! -f "$CONFIG" ]; then
    echo "Config file not found!"
    exit 1
fi

# Replace the assignment value
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$CONFIG"

echo "Assignment updated to '$new_assignment'. Running the reminder..."
bash "$DIR/startup.sh"

