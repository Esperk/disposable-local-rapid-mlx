#!/bin/bash
# Chat with the model that ./start.sh is serving, right in the terminal.
# Usage: ./chat.sh [port]   (default port: 8000)

# Make sure we're in the right directory
cd "$(dirname "$0")"

PORT="${1:-8000}"

# Check if setup was run
if [ ! -d ".venv" ]; then
  echo "Error: Virtual environment not found. Please run ./setup.sh first."
  exit 1
fi

# Check that a server is running
if ! curl -s -m 3 "http://127.0.0.1:$PORT/v1/models" > /dev/null; then
  echo "Error: No model server on port $PORT. Start one first with ./start.sh"
  exit 1
fi

source .venv/bin/activate
export HF_HOME="$(pwd)/.cache/huggingface"

# Connect to the existing server instead of loading a second copy of a model
rapid-mlx chat --base-url "http://127.0.0.1:$PORT"
