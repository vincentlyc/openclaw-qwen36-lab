#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y \
  build-essential \
  cmake \
  git \
  curl \
  wget \
  python3 \
  python3-pip \
  python3-venv \
  pkg-config

python3 -m pip install --user --upgrade huggingface_hub

echo "Dependencies installed."
