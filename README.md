# Persistent Reverse Shell for Linux
This repository contains scripts for setting up a persistent reverse shell connection. The connection utilizes encrypted configuration for enhanced security. It is designed to automatically restart and attempt reconnection at regular intervals, ensuring persistent access.

# Contents
**setup.sh**: A Bash script that installs required Python packages, sets up **persistence.py** as a system service for automatic startup, and executes **encrypt.py** to generate encrypted configuration.

**persistence.py**: A Python script that establishes a reverse shell connection to a specified server, automatically reconnecting every 20 seconds if the connection is lost.

**encrypt.py**: A Python script that prompts the user for connection details (LHOST and LPORT), encrypts this information using a provided key, and saves the encrypted data for **persistence.py** to use.

# How to Use
**Setup Environment**: Run **setup.sh** to install dependencies, copy scripts, and set up the systemd service. This script will prompt you for an encryption key—make sure to remember it as it is required for decrypting connection details.
Step : 1 Download

```
git clone https://github.com/byfranke/persistentshell
```
Step : 2 Move to directory
```
cd persistentshell
```
Step : 3 Permission to execute
```
chmod +x setup.sh
```
Step : 4 Run
```
sudo ./setup.sh
```
![image](https://github.com/byfranke/persistentshell/assets/131370932/05df01b5-7d41-41cf-9794-745e4813e00e)

**Configure Connection**: When running **setup.sh**, you will be prompted to enter **LHOST** and **LPORT** for your reverse shell connection. This information will be encrypted and saved.

**Service Management**: The **persistence.py** script is set up as a systemd service, ensuring it starts on boot and attempts to reconnect every 20 seconds if the connection drops.

# Customization
To change the IP address and port after initial setup, rerun **encrypt.py** with the new details and the same encryption key.

# Disclaimer
This tool is designed for educational and testing purposes only. The creator strictly discourages and disclaims any responsibility for its use in unauthorized or malicious activities. Always obtain explicit permission before deploying this tool in any environment.
