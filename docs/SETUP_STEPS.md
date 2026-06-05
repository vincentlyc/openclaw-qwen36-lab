# Setup Steps

以下步驟假設 repo 已 clone 到 WSL 內，且模型不會被 commit。

## 1. Windows PowerShell：設定 WSL

```powershell
cd openclaw-qwen36-lab-project
.\scripts\00_set_wsl_config.ps1
wsl --shutdown
```

重新開啟 WSL 後：

```bash
free -h
```

預期 WSL memory 約 15GB，swap 約 32GB。

## 2. WSL：安裝依賴

```bash
bash scripts/01_install_deps.sh
```

## 3. WSL：編譯 llama.cpp

```bash
bash scripts/02_build_llama_cpp.sh
```

注意：腳本使用 `-j 1`，避免在 16GB Windows RAM 的 WSL 環境中編譯 OOM。

## 4. WSL：下載模型

```bash
bash scripts/03_download_qwen36_model.sh
```

模型預設下載到：

```text
models/qwen36/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf
```

`models/` 已列入 `.gitignore`，不要上傳。

## 5. WSL：啟動 llama-server

```bash
bash scripts/04_run_qwen36_server.sh
```

預設 API endpoint：

```text
http://127.0.0.1:18000/v1
```

## 6. WSL：測試 API

另一個 terminal 執行：

```bash
bash scripts/05_test_qwen36_api.sh
```

## 7. OpenClaw 設定

使用 `configs/openclaw.local.qwen36.example.json` 作為範本，將 OpenClaw 指向：

- Base URL：`http://127.0.0.1:18000/v1`
- Model ID：`unsloth/Qwen3.6-35B-A3B-GGUF`
