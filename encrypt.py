from cryptography.fernet import Fernet

def encrypt_ip_port(ip_port, key_file='/tmp/.config/key', config_file='/tmp/.config/config.txt'):
    # Read the key from the key file
    with open(key_file, 'rb') as key_in:
        key = key_in.read()

    cipher_suite = Fernet(key)
    
    # Encrypt the data
    encrypted_data = cipher_suite.encrypt(ip_port.encode())
    
    # Write the encrypted IP and port to the config file
    with open(config_file, 'wb') as config_out:
        config_out.write(encrypted_data)

    print("Encryption complete. Key and encrypted data have been saved.")

# Prompt for LHOST and LPORT
lhost = input("Enter LHOST: ")
lport = input("Enter LPORT: ")
ip_port = f"{lhost}\n{lport}"
encrypt_ip_port(ip_port)
