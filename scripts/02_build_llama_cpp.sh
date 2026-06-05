#!/usr/bin/env bash
set -euo pipefail

LLAMA_DIR="${LLAMA_DIR:-llama.cpp}"
BUILD_DIR="$LLAMA_DIR/build"

if [[ ! -d "$LLAMA_DIR" ]]; then
  git clone https://github.com/ggml-org/llama.cpp.git "$LLAMA_DIR"
else
  git -C "$LLAMA_DIR" pull --ff-only
fi

cmake -S "$LLAMA_DIR" -B "$BUILD_DIR" \
  -DGGML_CUDA=ON \
  -DCMAKE_BUILD_TYPE=Release

# On 16GB Windows RAM + WSL, parallel builds can OOM. Keep this at -j 1.
cmake --build "$BUILD_DIR" --config Release -j 1 --target llama-server

if [[ ! -x "$BUILD_DIR/bin/llama-server" ]]; then
  echo "ERROR: llama-server was not built at $BUILD_DIR/bin/llama-server" >&2
  exit 1
fi

echo "Built: $BUILD_DIR/bin/llama-server"
