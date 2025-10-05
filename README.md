# 🚀 MLOps Week 2: Data & Model Versioning with DVC

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![DVC](https://img.shields.io/badge/DVC-Enabled-orange.svg)](https://dvc.org/)
[![GCS](https://img.shields.io/badge/Storage-Google%20Cloud-4285F4.svg)](https://cloud.google.com/storage)

A comprehensive MLOps project demonstrating **data versioning**, **model versioning**, and **experiment tracking** using DVC (Data Version Control) with Google Cloud Storage backend.

## 📋 Overview

This project implements a complete MLOps pipeline that:
- 🔄 Versions datasets and models using DVC
- 🌥️ Stores artifacts in Google Cloud Storage
- 🏷️ Creates Git tags for model versions
- 🤖 Trains Decision Tree models on Iris dataset
- 📊 Tracks model performance across versions

## 🏗️ Project Structure

```
week-2-mlops/
├── train.py              # ML training script
├── requirements.txt       # Python dependencies
├── run_workflow.sh       # Complete automation script
└── README.md            # This file
```

## 🎯 Features

- **Data Versioning**: Track different versions of the Iris dataset
- **Model Versioning**: Version trained models with different hyperparameters
- **Cloud Storage**: Remote storage using Google Cloud Storage
- **Git Integration**: Seamless integration with Git for code and metadata versioning
- **Automated Pipeline**: One-click execution of the entire workflow

## 🛠️ Prerequisites

- Python 3.8+
- Git
- Google Cloud CLI (`gcloud`)
- Google Cloud Storage bucket access

## ⚡ Quick Start

### 1. Clone and Setup
```bash
git clone https://github.com/Shridhar7-8/week-2-mlops.git
cd week-2-mlops
```

### 2. Run the Complete Workflow
```bash
chmod +x run_workflow.sh
./run_workflow.sh
```

This script will automatically:
1. ✅ Set up Python environment
2. 📦 Install dependencies
3. 🔧 Initialize DVC
4. ☁️ Configure Google Cloud Storage
5. 📊 Import and version datasets
6. 🤖 Train and version models
7. 🔄 Demonstrate version control

## 📚 Manual Execution

If you prefer to run steps manually:

### Environment Setup
```bash
python3 -m venv .env
source .env/bin/activate
pip install -r requirements.txt
pip install dvc[gcs]
```

### DVC Initialization
```bash
dvc init
mkdir artifacts
gcloud auth application-default login
dvc remote add -d gcs_remote gs://mlops-course-cellular-gift-473007-n6-unique/dvc-storage
```

### Version 1.0 Workflow
```bash
# Import v1 dataset
dvc import --rev week_1 \
    https://github.com/IITMBSMLOps/ga_resources.git \
    data/v1/data.csv -o data/iris.csv

# Train model v1 (depth=3)
python train.py --data data/iris.csv --model artifacts/model.joblib --depth 3

# Version the model
dvc add artifacts/model.joblib
git add . && git commit -m "Model v1.0"
git tag -a "v1.0" -m "Model v1.0 on dataset v1"
```

### Version 2.0 Workflow
```bash
# Import v2 dataset
dvc import --rev week_1 \
    https://github.com/IITMBSMLOps/ga_resources.git \
    data/v2/data.csv -o data/iris.csv

# Train model v2 (depth=4)
python train.py --data data/iris.csv --model artifacts/model.joblib --depth 4

# Version the model
dvc add artifacts/model.joblib
git add . && git commit -m "Model v2.0"
git tag -a "v2.0" -m "Model v2.0 on dataset v2"
```

### Push and Deploy
```bash
# Push all artifacts to cloud storage
dvc push

# Demonstrate version switching
git checkout v1.0 && dvc checkout  # Switch to v1.0
git checkout main && dvc checkout   # Return to latest
```

## 🔄 Version Control

Switch between different model versions:

```bash
# Switch to version 1.0
git checkout v1.0
dvc checkout

# Switch to version 2.0
git checkout v2.0
dvc checkout

# Return to latest
git checkout main
dvc checkout
```

## 📊 Model Performance

| Version | Dataset | Max Depth | Accuracy | Features |
|---------|---------|-----------|----------|----------|
| v1.0    | v1      | 3         | ~0.95    | 4 (sepal/petal dimensions) |
| v2.0    | v2      | 4         | ~0.97    | 4 (sepal/petal dimensions) |

## 🧠 Training Script Usage

The `train.py` script accepts the following parameters:

```bash
python train.py --data <path_to_csv> --model <output_path> --depth <max_depth>
```

**Parameters:**
- `--data`: Path to the training data CSV file (required)
- `--model`: Path to save the trained model in joblib format (required)
- `--depth`: Maximum depth for the Decision Tree (default: 3)

**Example:**
```bash
python train.py --data data/iris.csv --model artifacts/model.joblib --depth 5
```

## 📦 Dependencies

Core dependencies defined in `requirements.txt`:

- **pandas**: Data manipulation and analysis
- **scikit-learn**: Machine learning library for model training
- **dvc[gcs]**: Data Version Control with Google Cloud Storage support
- **google-cloud-aiplatform**: Google Cloud AI Platform integration

## 🌟 Key MLOps Concepts Demonstrated

1. **📈 Reproducible Experiments**: Every model version is fully reproducible
2. **🔗 Data Lineage**: Complete tracking of which data was used for each model
3. **🏪 Model Registry**: Organized cloud storage of model artifacts
4. **🤖 Automated Pipelines**: Scripted workflows ensuring consistency
5. **☁️ Cloud Integration**: Scalable Google Cloud Storage solution
6. **🏷️ Version Tagging**: Git tags for easy model version management
7. **🔄 Rollback Capability**: Easy switching between model versions

## 🚀 Advanced Usage

### Custom Training
```bash
# Train with different hyperparameters
python train.py --data data/iris.csv --model artifacts/model_deep.joblib --depth 10

# Version your custom model
dvc add artifacts/model_deep.joblib
git add . && git commit -m "Custom model with depth=10"
git tag -a "custom-v1" -m "Custom deep model"
```

### Data Pipeline
```bash
# Import different dataset versions
dvc import --rev week_1 https://github.com/IITMBSMLOps/ga_resources.git data/v3/data.csv -o data/iris_v3.csv

# Train on new data
python train.py --data data/iris_v3.csv --model artifacts/model_v3.joblib --depth 5
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Submit a pull request

## 📄 License

This project is part of the MLOps course curriculum.

## 🆘 Troubleshooting

**Common Issues:**

1. **GCS Authentication Error**
   ```bash
   gcloud auth application-default login
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **DVC Remote Error**
   ```bash
   dvc remote modify gcs_remote url gs://your-bucket-name/dvc-storage
   ```

3. **Python Environment Issues**
   ```bash
   python3 -m venv .env --clear
   source .env/bin/activate
   pip install --upgrade pip
   ```

---

**Happy MLOps! 🚀🎯📊**
