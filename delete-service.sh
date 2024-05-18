#!/bin/bash

# Check if root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# List custom services matching the "nc-*" naming convention
echo "Listing custom services:"
systemctl list-units --type=service --state=running | grep ".service" | awk '{print $1}'
echo "Enter the full service name to delete (e.g., nc-datetime.service), or type 'exit' to quit:"
read SERVICE_NAME

# Handle user exit
if [ "$SERVICE_NAME" == "exit" ]; then
    echo "Exiting..."
    exit 0
fi

# Check if the service exists
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"
if [ ! -f "$SERVICE_FILE" ]; then
    echo "Service file does not exist: $SERVICE_FILE"
    exit 1
fi

# Confirm deletion
echo "Are you sure you want to delete $SERVICE_NAME? This cannot be undone. (yes/no)"
read CONFIRMATION
if [ "$CONFIRMATION" != "yes" ]; then
    echo "Deletion aborted."
    exit 0
fi

# Stop, disable and delete the service
echo "Stopping and disabling the service..."
systemctl stop $SERVICE_NAME
systemctl disable $SERVICE_NAME
rm -f $SERVICE_FILE
systemctl daemon-reload
systemctl reset-failed

# Optional: Remove log files
LOG_DIR="/var/log/$SERVICE_NAME"
if [ -d "$LOG_DIR" ]; then
    echo "Do you want to delete the log directory at $LOG_DIR? (yes/no)"
    read LOG_CONFIRM
    if [ "$LOG_CONFIRM" == "yes" ]; then
        rm -rf $LOG_DIR
        echo "Log directory deleted."
    else
        echo "Log directory not deleted."
    fi
fi

echo "$SERVICE_NAME has been deleted successfully."
