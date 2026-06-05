# Runbook

## Daily Start

1. 開啟 WSL。
2. 進入 repo：

   ```bash
   cd openclaw-qwen36-lab-project
   ```

3. 檢查記憶體：

   ```bash
   free -h
   ```

4. 檢查 GPU：

   ```bash
   nvidia-smi
   ```

5. 檢查 port：

   ```bash
   bash scripts/06_check_ports.sh
   ```

6. 啟動 server：

   ```bash
   bash scripts/04_run_qwen36_server.sh
   ```

7. 測試 API：

   ```bash
   bash scripts/05_test_qwen36_api.sh
   ```

## API Endpoint

```text
http://127.0.0.1:18000/v1
```

## Model ID

```text
unsloth/Qwen3.6-35B-A3B-GGUF
```

## Model File

```text
models/qwen36/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf
```

## Common Overrides

降低 context size：

```bash
CTX_SIZE=2048 bash scripts/04_run_qwen36_server.sh
```

限制 GPU layers：

```bash
N_GPU_LAYERS=40 bash scripts/04_run_qwen36_server.sh
```

改 port：

```bash
PORT=18001 bash scripts/04_run_qwen36_server.sh
```
