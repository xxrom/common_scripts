#!/bin/bash

# init command:
#/usr/bin/autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -i /home/adunda/.ssh/id_do -N -R 127.0.0.1:6061:localhost:6061 tt@178.128.195.181

# Assign command-line arguments to variables
PORT=$1

# Build the autossh command
COMMAND="/usr/bin/autossh -M 0 -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -o ServerAliveCountMax=300 -i /home/adunda/.ssh/id_do -N -R 127.0.0.1:$PORT:localhost:$PORT tt@178.128.195.181"

# Execute the tunnel command
echo ">>> MONITOR"

sudo sh ./monitor-add-cron.sh "tunnel-monitor-$PORT" "178.128.195.181:$PORT" "nc-tunnel-$PORT"

echo ">>> TUNNEL-SERVICE"
echo "$COMMAND"
sh ./service-create.sh "tunnel-$PORT" "$COMMAND"
