#!/bin/bash
set -e

echo "Setting up Rapid-MLX in an isolated environment..."

# Ensure python3 is installed and is at least 3.10
if ! command -v python3 &> /dev/null; then
  echo "Error: python3 is not installed or not in PATH."
  exit 1
fi

if ! python3 -c 'import sys; exit(0 if sys.version_info >= (3, 10) else 1)'; then
  echo "Error: Python 3.10 or newer is required. Your python3 is:"
  python3 --version
  exit 1
fi

# 1. Create a Python virtual environment
echo "Creating python virtual environment in .venv..."
python3 -m venv .venv

# 2. Activate the virtual environment
source .venv/bin/activate

# 3. Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# 4. Install rapid-mlx (with vision support just in case)
echo "Installing rapid-mlx..."
pip install -U 'rapid-mlx[vision]'

# 5. Create local cache directory for Hugging Face models
# This ensures that when downloading large models, they stay in this folder.
# Deleting this local-llm folder will clean up everything, including the models.
echo "Creating local model cache directory..."
mkdir -p .cache/huggingface

echo ""
echo "Setup complete!"
echo "To start the server, use: ./start.sh <model-name>"
echo "Example: ./start.sh mlx-community/Llama-3.2-3B-Instruct-4bit"
