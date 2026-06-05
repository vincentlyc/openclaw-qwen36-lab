#!/usr/bin/env bash
set -euo pipefail

LLAMA_SERVER="${LLAMA_SERVER:-llama.cpp/build/bin/llama-server}"
MODEL_PATH="${MODEL_PATH:-models/qwen36/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf}"
HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-18000}"
CTX_SIZE="${CTX_SIZE:-4096}"
N_GPU_LAYERS="${N_GPU_LAYERS:--1}"
MODEL_ALIAS="${MODEL_ALIAS:-unsloth/Qwen3.6-35B-A3B-GGUF}"

if [[ ! -x "$LLAMA_SERVER" ]]; then
  echo "ERROR: llama-server not found or not executable: $LLAMA_SERVER" >&2
  echo "Run: bash scripts/02_build_llama_cpp.sh" >&2
  exit 1
fi

if [[ ! -f "$MODEL_PATH" ]]; then
  echo "ERROR: model file not found: $MODEL_PATH" >&2
  echo "Run: bash scripts/03_download_qwen36_model.sh" >&2
  exit 1
fi

exec "$LLAMA_SERVER" \
  --model "$MODEL_PATH" \
  --alias "$MODEL_ALIAS" \
  --host "$HOST" \
  --port "$PORT" \
  --ctx-size "$CTX_SIZE" \
  --n-gpu-layers "$N_GPU_LAYERS"
