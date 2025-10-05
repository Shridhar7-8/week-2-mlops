import argparse
import os
import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn import metrics

def run_training(data_path, model_path, max_depth):
    """Loads data, trains a model, evaluates it, and saves it."""
    df = pd.read_csv(data_path)
    X = df[['sepal_length', 'sepal_width', 'petal_length', 'petal_width']]
    y = df['species']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.4, stratify=y, random_state=42)
    model = DecisionTreeClassifier(max_depth=max_depth, random_state=42)
    model.fit(X_train, y_train)
    prediction = model.predict(X_test)
    accuracy = metrics.accuracy_score(prediction, y_test)
    print(f"✅ Model training complete. Accuracy: {accuracy:.4f}")
    joblib.dump(model, model_path)
    print(f"💾 Model saved to {model_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--data", required=True, help="Path to the training data CSV file.")
    parser.add_argument("--model", required=True, help="Path to save the trained model.")
    parser.add_argument("--depth", type=int, default=3, help="Max depth for the Decision Tree.")
    args = parser.parse_args()
    run_training(args.data, args.model, args.depth)