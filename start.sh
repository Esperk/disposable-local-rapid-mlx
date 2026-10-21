#!/bin/bash

# Make sure we're in the right directory
cd "$(dirname "$0")"

# Load environment variables from .env file (like HF_TOKEN)
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# Without an argument, choose from the models that are already downloaded
if [ -z "$1" ]; then
  MODEL_NAME="$(./models.sh pick)" || exit 1
else
  MODEL_NAME=$1
fi

# Check if setup was run
if [ ! -d ".venv" ]; then
  echo "Error: Virtual environment not found. Please run ./setup.sh first."
  exit 1
fi

# Activate the virtual environment
source .venv/bin/activate

# Set Hugging Face cache to the local folder so models are containerized
export HF_HOME="$(pwd)/.cache/huggingface"

echo "Starting Rapid-MLX with model: $MODEL_NAME"
echo "Models will be cached in: $HF_HOME"
echo "To chat with it, run ./chat.sh in another terminal (or open the web UI, see README)"
echo ""

# Start the server
rapid-mlx serve "$MODEL_NAME"
