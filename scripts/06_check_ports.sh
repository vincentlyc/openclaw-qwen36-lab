#!/usr/bin/env bash
set -euo pipefail

PORTS=(8000 8001 18000)

for port in "${PORTS[@]}"; do
  echo "== Port $port =="
  if command -v ss >/dev/null 2>&1; then
    ss -ltnp "sport = :$port" || true
  elif command -v lsof >/dev/null 2>&1; then
    lsof -iTCP:"$port" -sTCP:LISTEN || true
  else
    netstat -ltnp 2>/dev/null | awk -v p=":$port" '$4 ~ p { print }' || true
  fi
  echo
done
