import requests
import time

# Your remote scoring URL
URL = "https://peter-walker.com/koth.php"
FILE_PATH = "/root/king.txt"

print("KOTH Agent Started. Monitoring the hill...")

while True:
    try:
        with open(FILE_PATH, 'r') as f:
            current_king = f.read().strip()
        
        if current_king:
            response = requests.post(URL, data={'name': current_king}, timeout=5)
            print(f"Current King: {current_king} - Status: {response.status_code}")
        
    except Exception as e:
        print(f"Error connecting to scoring server: {e}")
    
    time.sleep(10)