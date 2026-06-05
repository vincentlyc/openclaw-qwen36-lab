#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:18000/v1}"
MODEL="${MODEL:-unsloth/Qwen3.6-35B-A3B-GGUF}"

curl -sS "$BASE_URL/chat/completions" \
  -H 'Content-Type: application/json' \
  -d @- <<JSON
{
  "model": "$MODEL",
  "messages": [
    {"role": "system", "content": "You are a concise local LLM test assistant."},
    {"role": "user", "content": "請用繁體中文回答：llama-server API 測試成功了嗎？"}
  ],
  "temperature": 0.2,
  "max_tokens": 128
}
JSON

echo
