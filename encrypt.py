from cryptography.fernet import Fernet

def encrypt_ip_port(ip_port, key_file='/tmp/.config/key', config_file='/tmp/.config/config.txt'):
    key = Fernet.generate_key()
    cipher_suite = Fernet(key)

    encrypted_data = cipher_suite.encrypt(ip_port.encode())

    with open(key_file, 'wb') as key_out:
        key_out.write(key)

    with open(config_file, 'wb') as config_out:
        config_out.write(encrypted_data)

    print("Encryption complete. Key and encrypted data have been saved.")

try:
    lhost = input("Enter LHOST: ")
    lport = input("Enter LPORT: ")
    ip_port = f"{lhost}\n{lport}"
    encrypt_ip_port(ip_port)
except KeyboardInterrupt:
    print("\nOperation cancelled by the user.")
