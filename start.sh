#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./start.sh <model-name>"
  echo "Example: ./start.sh mlx-community/Llama-3.2-3B-Instruct-4bit"
  exit 1
fi

MODEL_NAME=$1

# Make sure we're in the right directory
cd "$(dirname "$0")"

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
echo ""

# Start the server
rapid-mlx serve "$MODEL_NAME"
