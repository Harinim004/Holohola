# HoloHola 👋📱🌐

**HoloHola** is an innovative AR-based video calling app that brings holographic communication to life! Using advanced AR technologies and real-time emotion detection, 
HoloHola displays an AR avatar of the caller that reacts with human-like expressions based on their emotions. Designed using Unity 6, ARCore, and Flutter, this app redefines the way we connect.

---

## 🌟 Features

- 📲 **AR-Based Calling**: See your contact as a 3D avatar in your physical space.
- 😃 **Real-Time Emotion Detection**: Voice is analyzed live to detect and reflect emotions on the AR avatar.
- 🔄 **Cross-Platform Communication**: Built using Unity for AR rendering and Flutter for a smooth mobile experience.
- 🧠 **AI-Powered Emotion Analysis**: Uses a DistilRoBERTa model to understand emotions from speech.
- 🔗 **Seamless Integration**: Python Flask API bridges the Unity and AI modules in real time.
- 🧑‍🤝‍🧑 **Minimal and Intuitive UI**: Designed with accessibility in mind, usable even by non-tech-savvy users.

---

## 📱 Download the App

You can try out the latest APK here:

👉 [Download HoloHola APK](https://drive.google.com/drive/folders/1HyFNdxg9OA5C5t9dx4iSr4WRcbhTh6sQ?usp=sharing)
*(Please make sure to allow installation from unknown sources on your Android device)*

---

## 🛠 Tech Stack

| Module       | Technology Used                |
|--------------|--------------------------------|
| AR Rendering | Unity 6 + ARCore               |
| Frontend     | Flutter                        |
| Backend API  | Python Flask                   |
| Emotion AI   | DistilRoBERTa (Hugging Face)   |
| UI Elements  | TextMeshPro in Unity + Flutter |
| Voice Input  | Python SpeechRecognition       |

---

## 💡 Architecture Overview

```mermaid
graph TD
    User -->|Speaks| FlutterApp
    FlutterApp --> UnityAR
    FlutterApp -->|Voice| FlaskAPI
    FlaskAPI -->|Analyzes| EmotionModel
    EmotionModel -->|Emotion| FlaskAPI
    FlaskAPI -->|Sends| UnityAR
    UnityAR -->|Displays Emotion| Avatar
