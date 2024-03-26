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
**Changing IP Address and Port After Initial Setup**

To modify the IP address and port used by the tool after the initial setup, simply re-run the **encrypt.py** script, providing the new details along with the same encryption key used initially. This ensures that your updated settings remain secure and encrypted.

**Cleanup Options**

Beyond network settings customization, the installation script offers options to perform cleanup after installation or uninstallation is complete:

**Deleting the persistentshell Directory**: At the end of the installation, you will be asked whether you wish to delete the current directory **persistentshell**. This is useful for keeping your environment clean and removing any residual files from the installation process.

**Clearing Terminal Command History**: Along with the option to delete the directory, the script also offers the possibility to clear the terminal's command history. This action will remove all previously stored entries in the command history, providing an additional layer of privacy.

**Recommendations**

Always review the settings and options available before running the script to ensure you understand the actions that will be performed.
Remember to keep the encryption key used safe and accessible for future customizations or updates to the settings.

# Disclaimer
This tool is designed for educational and testing purposes only. The creator strictly discourages and disclaims any responsibility for its use in unauthorized or malicious activities. Always obtain explicit permission before deploying this tool in any environment.

