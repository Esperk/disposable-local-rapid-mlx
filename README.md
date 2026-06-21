# Local LLM Experimentation Setup

This project solves the problem of wanting to experiment with local LLMs using [Rapid-MLX](https://github.com/raullenchai/Rapid-MLX) on Apple Silicon without permanently cluttering your system. By keeping the Python environment and massive Hugging Face model downloads strictly containerized within this repository, you can easily throw the entire experiment away when you're done—simply delete the folder and no hidden multi-gigabyte artifacts will be left behind on your laptop.

## Features

- **Containerized Models**: Hugging Face models are downloaded to `.cache/` within this directory, keeping your global system clean.
- **Isolated Environment**: Python dependencies are kept in `.venv/`.
- **Easy Cleanup**: To completely remove the setup and all downloaded multi-gigabyte models, simply delete this `local-llm` folder.

## Requirements

- **Python**: You must have `python3` installed on your system with version **3.10 or newer**. (Python 3.9 will not work).

## Setup

First, run the setup script to create the virtual environment and install Rapid-MLX:

```bash
./setup.sh
```

## Running a Model

Once setup is complete, use the start script and provide a model name from the Hugging Face hub (specifically `mlx-community` models for Apple Silicon):

```bash
./start.sh mlx-community/Llama-3.2-3B-Instruct-4bit
```

This will automatically download the model (if it's not already in `.cache/`) and start an OpenAI-compatible API server on your local machine.

### Other Recommended Models to Try

**Text/Code Models:**
- **Qwen 2.5 (Fast & Smart)**: `mlx-community/Qwen2.5-7B-Instruct-4bit`
- **Phi 3.5 (Small & Fast)**: `mlx-community/Phi-3.5-mini-instruct-4bit`

**Vision Models (Image Understanding):**
- **Qwen2-VL (Excellent Multimodal)**: `mlx-community/Qwen2-VL-7B-Instruct-4bit`
- **Llama 3.2 Vision (Strong overall)**: `mlx-community/Llama-3.2-11B-Vision-Instruct-4bit`
- **Pixtral 12B**: `mlx-community/pixtral-12b-4bit`

## Usage with Cursor/Claude Code/etc.

Rapid-MLX runs an OpenAI-compatible API server. 

By default, it will be available at `http://localhost:8080/v1` (check console output for exact port). 
You can use this URL as a custom OpenAI endpoint in your favorite tools, and set the API key to anything (e.g. `sk-local`).

---
*Note: This repository and its scripts were generated with the assistance of an AI coding agent.*
