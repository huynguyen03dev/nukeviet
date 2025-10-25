import requests
import os

word = "fire"
api_url = f"https://api.dictionaryapi.dev/api/v2/entries/en/{word}"

try:
    # 1. Get the word data from the API
    response = requests.get(api_url)
    response.raise_for_status()  # Raise an error for bad responses (404, 500, etc.)
    data = response.json()

    # 2. Find the first available audio URL
    audio_url = None
    if isinstance(data, list) and len(data) > 0:
        phonetics = data[0].get("phonetics", [])
        for p in phonetics:
            if p.get("audio"):
                audio_url = p["audio"]
                break
    
    if not audio_url:
        print(f"No audio found for '{word}'.")
        exit()

    # 3. Handle URLs that start with "//"
    if audio_url.startswith("//"):
        audio_url = "https:" + audio_url
        
    print(f"Found audio URL: {audio_url}")

    # 4. Download the audio file
    audio_response = requests.get(audio_url)
    audio_response.raise_for_status()

    # 5. Save the file
    file_name = f"{word}_pronunciation.mp3"
    with open(file_name, "wb") as f:
        f.write(audio_response.content)
        
    print(f"Successfully downloaded and saved to {file_name}")

except requests.exceptions.HTTPError as err:
    print(f"HTTP error: {err}")
except requests.exceptions.RequestException as e:
    print(f"An error occurred: {e}")