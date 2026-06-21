import time
import argparse
from dotenv import load_dotenv
from mlx_lm import load, generate

# Load environment variables from .env file (like HF_TOKEN)
load_dotenv()

def benchmark(model_path, prompt, max_tokens):
    print(f"Loading model: {model_path}")
    start_load = time.time()
    
    # Load the model and tokenizer using mlx_lm
    # This automatically uses the GPU optimally on Apple Silicon
    model, tokenizer = load(model_path)
    
    print(f"Loaded in {time.time() - start_load:.2f} seconds")
    print(f"\nPrompt: {prompt}")
    print("-" * 50)
    
    # mlx_lm's generate method handles the generation and printing
    # When verbose=True, it automatically outputs tokens/sec benchmark stats at the end.
    response = generate(
        model, 
        tokenizer, 
        prompt=prompt, 
        verbose=True, 
        max_tokens=max_tokens
    )
    
    print("-" * 50)
    print("Benchmark complete.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Benchmark an MLX model on Apple Silicon.")
    parser.add_argument(
        "--model", 
        type=str, 
        default="mlx-community/Qwen2.5-Coder-7B-Instruct-4bit", 
        help="Hugging Face model path"
    )
    parser.add_argument(
        "--prompt", 
        type=str, 
        default="Write a python script to calculate the Fibonacci sequence.", 
        help="Prompt to run through the model"
    )
    parser.add_argument(
        "--max-tokens", 
        type=int, 
        default=200, 
        help="Maximum tokens to generate"
    )
    args = parser.parse_args()
    
    benchmark(args.model, args.prompt, args.max_tokens)
