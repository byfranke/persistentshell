#!/bin/bash

# Variables
SERVICE_NAME="persistence"
TIMER_NAME="${SERVICE_NAME}.timer"
TARGET_DIR="/usr/local/bin"
SCRIPT_NAME="persistence.py"
CONFIG_FILE="/tmp/.config/config.txt"
KEY_FILE="/tmp/.config/key"

# Stop and disable the systemd service and timer
echo "Stopping and disabling $TIMER_NAME..."
systemctl stop "$TIMER_NAME"
systemctl disable "$TIMER_NAME"
echo "Stopping and disabling $SERVICE_NAME..."
systemctl stop "$SERVICE_NAME"
systemctl disable "$SERVICE_NAME"

# Remove the systemd service and timer files
echo "Removing systemd service and timer files..."
rm -f "/etc/systemd/system/$SERVICE_NAME.service"
rm -f "/etc/systemd/system/$TIMER_NAME"

# Reload systemd to apply changes
systemctl daemon-reload
systemctl reset-failed

# Remove the script, config file, and key
echo "Removing script, configuration, and key files..."
rm -f "$TARGET_DIR/$SCRIPT_NAME"
rm -f "$CONFIG_FILE"
rm -f "$KEY_FILE"

# Final cleanup actions, like removing the /tmp/.config directory if it's empty
if [ -d "/tmp/.config" ] && [ -z "$(ls -A /tmp/.config)" ]; then
    echo "Removing empty directory /tmp/.config..."
    rmdir "/tmp/.config"
fi

# Prompt to delete the current working directory
read -p "Do you wish to delete the current directory ($PWD)? [y/n]: " del_choice

case $del_choice in
    [Yy]* )
        echo "Deleting the current directory..."
        # Move up a directory to avoid issues with deleting the current directory
        cd ..
        # Delete the directory
        rm -rf "$PWD/persistentshell"
        echo "Directory deleted."
        
        # Clean up command history after confirming deletion
        echo "Cleaning up terminal command history..."
        history -c && > ~/.bash_history
        echo "Command history cleaned."
        ;;
    [Nn]* )
        echo "Directory not deleted."
        ;;
    * )
        echo "Invalid choice. Directory not deleted."
        ;;
esac

echo "Uninstallation complete."
