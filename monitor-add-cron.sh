#!/bin/bash

# Get inputs
name=$1 # unique name for the job:
url=$2 # Enter URL to monitor:
service_name=$3 # service to restart if not reachable

current_dir=$PWD #"/home/adunda/common_scripts" #$PWD
sleep_timeout=60

# Command to be scheduled
monitor_command="$current_dir/monitor.sh $name $url $sleep_timeout 'systemctl stop $service_name.service && systemctl start $service_name.service'"
full_command="@reboot sleep 60 && $monitor_command"

# Check if the cron job already exists
existing_jobs=$(sudo crontab -l | grep "/monitor.sh $name" | grep -v '^#')

if [ -z "$existing_jobs" ]; then
    # Add new cron job if no existing job found
    (sudo crontab -l 2>/dev/null; echo "$full_command") | crontab -
    echo "Cron job added: $full_command"
    sudo /bin/sh -c "sudo sh $monitor_command &"
else
    echo "A cron job with the specified name already exists:"
    echo "----------"
    echo "$existing_jobs"
    echo "----------"
    sudo /bin/sh -c "sudo sh $monitor_command &"
fi
