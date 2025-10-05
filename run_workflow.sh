# --- 1. CLONE YOUR REPO AND SETUP THE ENVIRONMENT ---
echo "🚀 Cloning your repository and setting up the environment..."
# Assuming you run this script *after* cloning, we skip the git clone step
git clone https://github.com/Shridhar7-8/week-2-mlops.git
# cd week-2-mlops

# Create and activate a Python virtual environment
python3 -m venv .env
source .env/bin/activate

# Install all required packages from your requirements.txt
pip install -r requirements.txt
pip install dvc[gcs] # Ensure DVC with GCS support is installed

# --- 2. INITIALIZE DVC AND SETUP ARTIFACTS FOLDER ---
echo "Initializing DVC and preparing folders..."
dvc init
mkdir artifacts # Create directory for model outputs if it doesn't exist

gcloud auth application-default login

# --- 3. CONFIGURE DVC REMOTE STORAGE AND COMMIT ---
echo "Configuring DVC to use Google Cloud Storage..."
dvc remote add -d gcs_remote gs://mlops-course-cellular-gift-473007-n6-unique/dvc-storage

# Add DVC configuration to Git
git add .dvc .gitignore
git commit -m "Initialize DVC and configure GCS remote"

# --- 4. WORKFLOW FOR DATA VERSION 1 (Using dvc import) ---
echo "--- Starting Workflow for Version 1.0 (Importing v1 data) ---"
# Track the v1 dataset by importing it directly from the 'week_1' branch
dvc import \
    --rev week_1 \
    https://github.com/IITMBSMLOps/ga_resources.git \
    data/v1/data.csv \
    -o data/iris.csv

# Commit the DVC pointer for the v1 data
git add data/iris.csv.dvc
git commit -m "Track dataset v1 (imported via dvc import)"

# Train the first model on the v1 data
python train.py --data data/iris.csv --model artifacts/model.joblib --depth 3

# Track the v1 model artifact and create a Git tag
dvc add artifacts/model.joblib
git add artifacts/model.joblib.dvc
git commit -m "Train and track model v1 (depth=3)"
git tag -a "v1.0" -m "Model v1.0 on dataset v1"

# --- 5. WORKFLOW FOR DATA VERSION 2 (Using dvc import) ---
echo "--- Starting Workflow for Version 2.0 (Importing v2 data) ---"
# Track the v2 dataset, which updates the v1 pointer
dvc import \
    --rev week_1 \
    https://github.com/IITMBSMLOps/ga_resources.git \
    data/v2/data.csv \
    -o data/iris_1.csv

# Commit the DVC pointer for the v2 data
git add data/iris.csv.dvc
git commit -m "Track dataset v2 (imported via dvc import)"

# Train a new model on the v2 data
python train.py --data data/iris.csv --model artifacts/model.joblib --depth 4

# Track the v2 model artifact and create a Git tag
dvc add artifacts/model.joblib
git add artifacts/model.joblib.dvc
git commit -m "Train and track model v2 (depth=4)"
git tag -a "v2.0" -m "Model v2.0 on dataset v2"

# --- 6. PUSH TO REMOTE AND DEMONSTRATE VERSION TRAVERSAL ---
echo "--- Pushing all versioned files to GCS ---"
dvc push

echo "--- Demonstrating Version Traversal ---"
echo "==> Checking out version 1.0..."
git checkout v1.0
dvc checkout
echo "Data and model files for v1.0 are now active."
ls -lh data/iris.csv artifacts/model.joblib

echo "==> Checking out latest version (v2.0)..."
git checkout main
dvc checkout
echo "Data and model files for v2.0 are now active."
ls -lh data/iris.csv artifacts/model.joblib

echo "✅ All objectives are complete!"