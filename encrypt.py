from cryptography.fernet import Fernet

# Function to encrypt IP and port with automatic key generation
def encrypt_ip_port(ip_port, key_file='/tmp/.config/key', config_file='/tmp/.config/config.txt'):
    # Generates a key and creates a Fernet instance
    key = Fernet.generate_key()
    cipher_suite = Fernet(key)

    # Encrypts the data
    encrypted_data = cipher_suite.encrypt(ip_port.encode())

    # Saves the key in a file
    with open(key_file, 'wb') as key_out:
        key_out.write(key)

    # Saves the encrypted IP and port in the configuration file
    with open(config_file, 'wb') as config_out:
        config_out.write(encrypted_data)

    print("Encryption complete. Key and encrypted data have been saved.")

# Asking the user for LHOST and LPORT, or setting them directly
lhost = input("Enter LHOST: ")
lport = input("Enter LPORT: ")
ip_port = f"{lhost}\n{lport}"
encrypt_ip_port(ip_port)
