#!/usr/bin/env bash
set -euo pipefail

MODEL_REPO="${MODEL_REPO:-unsloth/Qwen3.6-35B-A3B-GGUF}"
MODEL_FILE="${MODEL_FILE:-Qwen3.6-35B-A3B-UD-Q4_K_M.gguf}"
MODEL_DIR="${MODEL_DIR:-models/qwen36}"

mkdir -p "$MODEL_DIR"

if ! command -v huggingface-cli >/dev/null 2>&1; then
  echo "huggingface-cli not found. Run scripts/01_install_deps.sh first." >&2
  exit 1
fi

huggingface-cli download "$MODEL_REPO" "$MODEL_FILE" \
  --local-dir "$MODEL_DIR" \
  --local-dir-use-symlinks False

echo "Downloaded to: $MODEL_DIR/$MODEL_FILE"
