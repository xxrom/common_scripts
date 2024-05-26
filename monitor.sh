#!/bin/bash

# Check for the required number of arguments
if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <NAME> <URL> <sleep timeout in seconds> <restart command>"
    echo "Usage $#: $0 $1 $2 $3 $4"
    exit 1
fi
echo "START $#: $0 $1 $2 $3 $4"

# Assign arguments to variables
name="nc-$1"
url=$2
sleep_timeout=$3
restart_command=$4

# Log file location
logpath="/var/log/monitor-log"
logfile="$logpath/$name.log"

# Function to check and create the log file if it doesn't exist
ensure_logfile_exists() {
    if [ ! -f "$logfile" ]; then
        touch "$logfile"
        chmod 666 "$logfile"
        echo "Created log file: $logfile"
    else
        echo "Already created log file: $logfile"
    fi
}

ensure_logfile_exists

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$logfile"
}

while true; do
    # Perform the check
    if curl -s --head "$url" | grep -q "200 OK"; then
        log "^"
    else
        log "Service is down. Restarting: '$name'"
        eval "$restart_command"
    fi

    sleep "$sleep_timeout"
done
