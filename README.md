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

### Hugging Face Token (Optional)

A token is only needed for gated models (e.g. official Meta/Google repos) and gives faster, less rate-limited downloads. Create one at [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens) (read access is enough) and put it in a `.env` file in this folder:

```bash
echo 'HF_TOKEN=hf_your_token_here' > .env
```

`.env` is git-ignored and loaded automatically by `start.sh`, `models.sh` and `benchmark.py`.

## Running a Model

Once setup is complete, use the start script and provide a model name from the Hugging Face hub (specifically `mlx-community` models for Apple Silicon):

```bash
./start.sh mlx-community/Llama-3.2-3B-Instruct-4bit
```

This will automatically download the model (if it's not already in `.cache/`) and start an OpenAI-compatible API server on your local machine.

To pick from the models you've already downloaded, run it without arguments:

```bash
./start.sh
```

### Managing Models

```bash
./models.sh                 # list downloaded models and their sizes
./models.sh pull <model>    # download a model without starting it
./models.sh rm [model]      # delete a model (choose from a list if no name is given)
```

### Other Recommended Models to Try

**Text/Code Models:**
- **Qwen 2.5 (Fast & Smart)**: `mlx-community/Qwen2.5-7B-Instruct-4bit`
- **Phi 3.5 (Small & Fast)**: `mlx-community/Phi-3.5-mini-instruct-4bit`

**Uncensored / Unfiltered Models (Fewer Alignment Constraints):**
- **Dolphin 2.9.4 Llama 3.1 (Smart & Uncensored)**: `mlx-community/dolphin-2.9.4-llama3.1-8b-4bit`
- **Dolphin 2.9.3 Qwen 2 (Very Fast & Lightweight)**: `mlx-community/dolphin-2.9.3-qwen2-1.5b-4bit`

**Heretic Models (Abliterated with [Heretic](https://github.com/p-e-w/heretic)):**
- **Gemma 4 26B-A4B Heretic (Recommended, ~15 GB)**: `mlx-community/gemma-4-26B-A4B-it-heretic-4bit`
- **Gemma 4 E2B Heretic (Very Fast, ~2 GB)**: `deadbydawn101/gemma-4-E2B-Heretic-Uncensored-mlx-4bit`
- **Gemma 4 31B Heretic (Dense, ~17 GB)**: `mlx-community/gemma-4-31B-it-uncensored-heretic-4bit`
- **Qwen 3.6 35B-A3B Heretic (Strong, ~20 GB)**: `froggeric/Qwen3.6-35B-A3B-Uncensored-Heretic-MLX-4bit`

*Note: Only use MLX builds. GGUF, `MTPLX`, `oQ…` and `dflash` variants won't load in Rapid-MLX.*

**Vision Models (Image Understanding):**
- **Qwen2-VL (Excellent Multimodal)**: `mlx-community/Qwen2-VL-7B-Instruct-4bit`
- **Llama 3.2 Vision (Strong overall)**: `mlx-community/Llama-3.2-11B-Vision-Instruct-4bit`
- **Pixtral 12B**: `mlx-community/pixtral-12b-4bit`

## Web Chat Interface (Open WebUI)

A local web interface is provided via [Open WebUI](https://github.com/open-webui/open-webui), allowing you to interact with the running model in a ChatGPT-like interface.

### Running the Web UI

1. First, make sure you have started your model server (e.g., `./start.sh mlx-community/Llama-3.2-3B-Instruct-4bit`).
2. Start the web interface container:
   ```bash
   docker compose up -d
   ```
3. Open your browser and navigate to:
   ```
   http://localhost:3000
   ```
   *Note: Authentication is disabled (`WEBUI_AUTH=False`) for single-user local convenience, so you will be logged in automatically.*

### Stopping the Web UI

To stop the web interface container, run:
```bash
docker compose down
```

## Usage with Cursor/Claude Code/etc.

Rapid-MLX runs an OpenAI-compatible API server. 

By default, it will be available at `http://localhost:8000/v1` (check console output for exact port). 
You can use this URL as a custom OpenAI endpoint in your favorite tools, and set the API key to anything (e.g. `sk-local`).

---
*Note: This repository and its scripts were generated with the assistance of an AI coding agent.*
