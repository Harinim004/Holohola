# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app

# initialize_app()
#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")
import speech_recognition as sr
from transformers import pipeline
import threading
import json

# Initialize emotion analysis pipeline
emotion_analyzer = pipeline("text-classification", model="j-hartmann/emotion-english-distilroberta-base")

# Initialize speech recognizer
recognizer = sr.Recognizer()

# Adjust the energy threshold based on your environment. A higher value makes it more selective.
recognizer.energy_threshold = 300  # You can fine-tune this based on your noise level
recognizer.dynamic_energy_threshold = False  # Disable dynamic energy thresholding

def analyze_emotion(text):
    """Analyze and print emotion in the text as JSON."""
    try:
        if text.strip():  # Only analyze if text is not empty
            results = emotion_analyzer(text)
            output = []
            for result in results:
                output.append({"emotion": result['label'], "confidence": result['score']})
            print(json.dumps({"text": text, "analysis": output}, indent=4))
    except Exception as e:
        print(json.dumps({"error": str(e)}))

def speech_to_text():
    """Convert speech to text with optimized noise reduction."""
    try:
        with sr.Microphone() as source:
            print("Listening for your voice...")
            
            # Adjust for ambient noise in the background (short duration for faster adjustment)
            recognizer.adjust_for_ambient_noise(source, duration=0.2)
            
            # Continuously listen until speech ends and immediately stop listening after silence
            audio = recognizer.listen(source, timeout=2)

        text = recognizer.recognize_google(audio)
        print(json.dumps({"text": text}))
        return text
    except sr.UnknownValueError:
        print(json.dumps({"error": "Could not understand the speech."}))
    except sr.RequestError:
        print(json.dumps({"error": "Speech service is down."}))
    except Exception as e:
        print(json.dumps({"error": str(e)}))
    return None

def speech_to_emotion():
    """Continuously listen to speech and analyze emotions quickly."""
    while True:
        text = speech_to_text()
        if text:
            # Run emotion analysis in a separate thread to not block recognition
            threading.Thread(target=analyze_emotion, args=(text,)).start()

if __name__ == "__main__":

    print("Speech-to-emotion analysis running... Press Ctrl+C to stop.")
    try:
        speech_to_emotion()
    except KeyboardInterrupt:
        print(json.dumps({"status": "Program stopped manually."}))
    except Exception as e:
        print(json.dumps({"error": str(e)}))