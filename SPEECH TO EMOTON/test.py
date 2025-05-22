from transformers import pipeline
from sklearn.metrics import accuracy_score, classification_report

# Load emotion detection model
emotion_analyzer = pipeline("text-classification", model="j-hartmann/emotion-english-distilroberta-base")

# Sample test dataset (text and actual emotion labels)
test_data = [
    ("I'm so happy today!", "joy"),
    ("I feel so sad and lonely.", "sadness"),
    ("This is so frustrating!", "anger"),
    ("I'm really scared of what might happen next.", "fear"),
    ("I feel nothing at all.", "neutral"),
    ("That was hilarious!", "joy"),
    ("I can't believe this happened, I'm so shocked.", "surprise"),
    ("I feel so disgusted right now.", "disgust"),
]

# Extract texts and true labels
texts, true_labels = zip(*test_data)

# Predict emotions using the model
predicted_results = [emotion_analyzer(text)[0]["label"] for text in texts]

# Compute accuracy and classification report
accuracy = accuracy_score(true_labels, predicted_results)
classification_rep = classification_report(true_labels, predicted_results, zero_division=0)

print(f"Accuracy: {accuracy:.2f}")
print("Classification Report:\n", classification_rep)
