#!/bin/bash

PORT=$1

# Script path
current_dir="/home/adunda/common_scripts" #$PWD
SCRIPT_PATH="$current_dir/tunnel-create.sh"

# Cron job setup to run every 5 minutes
full_command="@reboot $SCRIPT_PATH $PORT >/dev/null 2>&1"

# Add the cron job
(sudo crontab -l 2>/dev/null; echo "$full_command") | sudo crontab -

echo "Cron job added to maintain the SSH tunnel port: $PORT"
