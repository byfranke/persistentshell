#!/bin/bash

# Variables
SERVICE_NAME="persistence"
TIMER_NAME="${SERVICE_NAME}.timer"
TARGET_DIR="/usr/local/bin"
SCRIPT_NAME="persistence.py"
CONFIG_FILE="/tmp/.config/config.txt"
KEY_FILE="/tmp/.config/key"

echo "Stopping and disabling $TIMER_NAME..."
systemctl stop "$TIMER_NAME"
systemctl disable "$TIMER_NAME"
echo "Stopping and disabling $SERVICE_NAME..."
systemctl stop "$SERVICE_NAME"
systemctl disable "$SERVICE_NAME"

echo "Removing systemd service and timer files..."
rm -f "/etc/systemd/system/$SERVICE_NAME.service"
rm -f "/etc/systemd/system/$TIMER_NAME"

systemctl daemon-reload
systemctl reset-failed

echo "Removing script, configuration, and key files..."
rm -f "$TARGET_DIR/$SCRIPT_NAME"
rm -f "$CONFIG_FILE"
rm -f "$KEY_FILE"

if [ -d "/tmp/.config" ] && [ -z "$(ls -A /tmp/.config)" ]; then
    echo "Removing empty directory /tmp/.config..."
    rmdir "/tmp/.config"
fi

read -p "Do you wish to delete the current directory ($PWD)? [y/n]: " del_choice

case $del_choice in
    [Yy]* )
        echo "Deleting the current directory..."
        cd ..
        rm -rf "$PWD/persistentshell"
        echo "Directory deleted."
        
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
