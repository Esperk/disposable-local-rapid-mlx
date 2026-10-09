#!/bin/bash
# Manage the models cached in .cache/huggingface

# Make sure we're in the right directory
cd "$(dirname "$0")"

# Load environment variables from .env file (like HF_TOKEN)
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

export HF_HOME="$(pwd)/.cache/huggingface"
HUB_DIR="$HF_HOME/hub"

usage() {
  echo "Usage: ./models.sh [command]"
  echo ""
  echo "Commands:"
  echo "  list              List downloaded models and their sizes (default)"
  echo "  pull <model>      Download a model without starting it"
  echo "  rm [model]        Delete a downloaded model (picks interactively if omitted)"
  echo "  pick              Choose a downloaded model and print its name"
}

# Print the ids of all downloaded models, one per line
model_ids() {
  for dir in "$HUB_DIR"/models--*; do
    [ -d "$dir" ] || continue
    name="${dir##*/models--}"
    echo "${name/--//}"
  done
}

model_dir() {
  echo "$HUB_DIR/models--${1/\//--}"
}

list_models() {
  if [ -z "$(model_ids)" ]; then
    echo "No models downloaded yet. Try: ./models.sh pull mlx-community/Llama-3.2-3B-Instruct-4bit"
    return
  fi
  model_ids | while read -r id; do
    dir="$(model_dir "$id")"
    size="$(du -sh "$dir" 2>/dev/null | cut -f1)"
    note=""
    if [ -n "$(find "$dir/blobs" -name '*.incomplete' 2>/dev/null | head -1)" ]; then
      note="  (incomplete download)"
    fi
    printf "%6s  %s%s\n" "$size" "$id" "$note"
  done
  echo ""
  echo "Total: $(du -sh "$HUB_DIR" | cut -f1)"
}

# Let the user choose a downloaded model; prints the chosen id on stdout
pick_model() {
  ids="$(model_ids)"
  if [ -z "$ids" ]; then
    echo "No models downloaded yet. Pass a model name instead, e.g.:" >&2
    echo "  ./start.sh mlx-community/Llama-3.2-3B-Instruct-4bit" >&2
    return 1
  fi

  if command -v fzf &> /dev/null; then
    echo "$ids" | fzf --height=~15 --prompt="Model> "
    return
  fi

  PS3="Choose a model: "
  select id in $ids; do
    if [ -n "$id" ]; then
      echo "$id"
      return
    fi
  done
  return 1
}

pull_model() {
  if [ -z "$1" ]; then
    echo "Usage: ./models.sh pull <model-name>"
    exit 1
  fi
  if [ ! -d ".venv" ]; then
    echo "Error: Virtual environment not found. Please run ./setup.sh first."
    exit 1
  fi
  source .venv/bin/activate
  hf download "$1"
}

remove_model() {
  id="$1"
  if [ -z "$id" ]; then
    id="$(pick_model)" || exit 1
  fi
  dir="$(model_dir "$id")"
  if [ ! -d "$dir" ]; then
    echo "Error: $id is not downloaded."
    exit 1
  fi
  read -r -p "Delete $id ($(du -sh "$dir" | cut -f1))? [y/N] " answer
  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    rm -rf "$dir"
    echo "Deleted $id"
  else
    echo "Cancelled"
  fi
}

case "${1:-list}" in
  list|ls)      list_models ;;
  pull)         pull_model "$2" ;;
  rm|remove)    remove_model "$2" ;;
  pick)         pick_model ;;
  -h|--help|help) usage ;;
  *)            usage; exit 1 ;;
esac
