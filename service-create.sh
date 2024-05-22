#!/bin/bash

# Usage: ./service-create.sh servicename "command to execute"

# Define variables
SERVICE_NAME="nc-$1"
EXEC_COMMAND="$2"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
LOG_DIR="/var/log/service-logs"
LOG_FILE="$LOG_DIR/$SERVICE_NAME.log"

# Check if root
#if [[ $EUID -ne 0 ]]; then
#   echo "This script must be run as root"
#   exit 1
#fi

# Check parameters
if [ -z "$SERVICE_NAME" ] || [ -z "$EXEC_COMMAND" ]; then
    echo "Usage: $0 [Service Name] [Command]"
    exit 1
fi

# Create log directory and file
mkdir -p $LOG_DIR
touch $LOG_FILE
chown nobody:nogroup $LOG_DIR
chown nobody:nogroup $LOG_FILE

# Create systemd service file
cat <<EOF > $SERVICE_FILE
[Unit]
Description=Custom Service for $SERVICE_NAME
After=network.target

[Service]
Type=simple
ExecStart=/bin/sh -c "$EXEC_COMMAND >> $LOG_FILE 2>&1"
Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize new service and start the service
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME

# Output status
echo "$SERVICE_NAME service created and started."
systemctl status $SERVICE_NAME
