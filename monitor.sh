#!/bin/bash

# Assign arguments to variables
name=$1
url=$2
sleep_timeout=$3
restart_command=$4

# Log file location
logpath="/var/log/monitor"
logfile="$logpath/$name.log"

# Function to check and create the log file if it doesn't exist
ensure_logfile_exists() {
    if [ ! -f "$logfile" ]; then
        # Create the file and set appropriate permissions
        touch "$logfile"
        chmod 644 "$logfile"
        # Optionally set the owner of the logfile, uncomment and replace `youruser` with the appropriate user
        # chown youruser:youruser "$logfile"
        echo "Created log file: $logfile"
    fi
}

# Ensure the log file exists
ensure_logfile_exists

# Function to log messages with a timestamp
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$logfile"
}

# Check for the required number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <URL> <sleep timeout in seconds> <restart command>"
    exit 1
fi

while true; do
    # Perform the check
    if curl -s --head "$url" | grep -q "200 OK"; then
        current_state="Service is up and running. $1"
    else
        current_state="Service is down. Restarting the service."
        eval "$restart_command"
    fi

    log "$current_state"

    sleep "$sleep_timeout"
done
