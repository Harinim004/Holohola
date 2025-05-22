import sys
sys.path.append(r"C:\Users\alwin\AppData\Roaming\Python\Python313\site-packages")


from flask import Flask, request, jsonify
import speech_recognition as sr
from transformers import pipeline
import threading

# Initialize Flask app
app = Flask(__name__)

# Initialize the emotion detection model
emotion_analyzer = pipeline("text-classification", model="j-hartmann/emotion-english-distilroberta-base")

# Initialize speech recognition
recognizer = sr.Recognizer()
recognizer.energy_threshold = 300
recognizer.dynamic_energy_threshold = False

def analyze_emotion(text):
    try:
        if text.strip():
            results = emotion_analyzer(text)
            output = [{"emotion": result['label'], "confidence": result['score']} for result in results]
            return output
    except Exception as e:
        return [{"error": str(e)}]

@app.route('/emotion', methods=['POST'])
def analyze_emotion_api():
    try:
        audio_data = request.files.get('audio')
        if not audio_data:
            return jsonify({"error": "No audio file provided"}), 400

        audio = sr.AudioFile(audio_data)
        with audio as source:
            audio_data = recognizer.record(source)
            text = recognizer.recognize_google(audio_data)

            results = analyze_emotion(text)
            return jsonify({"text": text, "analysis": results})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

def speech_to_text():
    try:
        with sr.Microphone() as source:
            print("Listening...")
            recognizer.adjust_for_ambient_noise(source, duration=0.2)
            audio = recognizer.listen(source, timeout=5)

        text = recognizer.recognize_google(audio)
        print(f"Detected Speech: {text}")
        return text
    except sr.UnknownValueError:
        print("Speech not understood.")
        return None
    except sr.RequestError:
        print("Speech service unavailable.")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None

def speech_to_emotion():
    while True:
        text = speech_to_text()
        if text:
            threading.Thread(target=lambda: print(f"Emotion Analysis: {analyze_emotion(text)}")).start()

if __name__ == '__main__':
    print("Starting real-time speech-to-emotion detection and API service...")
    threading.Thread(target=speech_to_emotion).start()
    app.run(host='0.0.0.0', port=5000)
