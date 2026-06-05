# OpenClaw Qwen3.6 Local LLM Lab

這個 Git repo 用來記錄在 **WSL + RTX 3090** 環境中，部署 **OpenClaw + llama.cpp + Qwen3.6-35B-A3B-GGUF** 的完整流程、腳本與 troubleshooting。

> 本 repo **不存放模型本體**，只保存部署筆記、設定範例、腳本與除錯紀錄。

## 目標環境

- GPU：NVIDIA RTX 3090，24GB VRAM
- Windows 實體 RAM：16GB
- Linux 環境：WSL
- 推論後端：`llama.cpp` / `llama-server`
- OpenAI-compatible API endpoint：`http://127.0.0.1:18000/v1`

## 模型資訊

- Hugging Face model repo：`unsloth/Qwen3.6-35B-A3B-GGUF`
- OpenClaw model id：`unsloth/Qwen3.6-35B-A3B-GGUF`
- 使用量化檔：`Qwen3.6-35B-A3B-UD-Q4_K_M.gguf`

模型檔請下載到本機的 `models/` 目錄，但不要 commit 到 Git。

## Repo 結構

```text
openclaw-qwen36-lab-project/
├── README.md
├── scripts/
│   ├── 00_set_wsl_config.ps1
│   ├── 01_install_deps.sh
│   ├── 02_build_llama_cpp.sh
│   ├── 03_download_qwen36_model.sh
│   ├── 04_run_qwen36_server.sh
│   ├── 05_test_qwen36_api.sh
│   └── 06_check_ports.sh
├── configs/
│   └── openclaw.local.qwen36.example.json
├── docs/
│   ├── SETUP_STEPS.md
│   ├── TROUBLESHOOTING_QA.md
│   └── RUNBOOK.md
└── .gitignore
```

## 快速開始

### 1. 設定 WSL 記憶體與 swap

在 Windows PowerShell 執行：

```powershell
.\scripts\00_set_wsl_config.ps1
wsl --shutdown
```

重新開啟 WSL 後確認：

```bash
free -h
```

### 2. 安裝依賴

```bash
bash scripts/01_install_deps.sh
```

### 3. 編譯 llama.cpp

```bash
bash scripts/02_build_llama_cpp.sh
```

預設只要求 `llama-server` 可用，因為 OpenClaw 只需要 server endpoint。

### 4. 下載 Qwen3.6 GGUF 模型

```bash
bash scripts/03_download_qwen36_model.sh
```

預設下載：

```text
unsloth/Qwen3.6-35B-A3B-GGUF/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf
```

### 5. 啟動 llama-server

```bash
bash scripts/04_run_qwen36_server.sh
```

預設服務：

```text
http://127.0.0.1:18000/v1
```

### 6. 測試 API

```bash
bash scripts/05_test_qwen36_api.sh
```

### 7. 檢查 port 佔用

```bash
bash scripts/06_check_ports.sh
```

## OpenClaw 設定

參考 `configs/openclaw.local.qwen36.example.json`，重點如下：

- `base_url`：`http://127.0.0.1:18000/v1`
- `model`：`unsloth/Qwen3.6-35B-A3B-GGUF`

## 注意事項

- 不要 commit 模型檔：`*.gguf`、`*.bin`、`*.safetensors`、`*.pt`、`*.pth`
- 不要 commit `models/`、`venv/`、`llama.cpp/`、`.env`
- 不要 commit token、API key、password
- RTX 3090 24GB VRAM 跑 Q4_K_M 仍可能 CUDA OOM；可降低 `--ctx-size`、限制 `--n-gpu-layers`，或改用 Q3 量化。
