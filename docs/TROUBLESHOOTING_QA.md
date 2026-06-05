# Troubleshooting QA

## Q1：為什麼 WSL 編譯 llama.cpp 時 OOM？

A：當時 WSL 只有約 7.7Gi RAM，Swap 只有約 336Mi。`llama.cpp` 編譯時如果 CMake/Make 開太多 worker，很容易把記憶體吃滿，導致 OOM 或編譯中斷。

## Q2：為什麼 `.wslconfig` 沒有效果？

A：一開始 `.wslconfig` 是空檔，`Length = 0`，等於沒有設定任何 WSL2 memory/swap 限制。需要寫入 `[wsl2]` 區段，並執行 `wsl --shutdown` 後重新開啟 WSL。

## Q3：WSL memory 可以設成 24GB 嗎？

A：不適合。Windows 實體 RAM 只有 16GB，因此 WSL 不能設 24GB。雖然 RTX 3090 有 24GB VRAM，但那不是 Windows 系統 RAM。

## Q4：這台機器建議的 `.wslconfig` 是什麼？

A：正確設定是 `memory=15GB`、`swap=32GB`。範例：

```ini
[wsl2]
memory=15GB
swap=32GB
localhostForwarding=true
```

設定後在 Windows PowerShell 執行：

```powershell
wsl --shutdown
```

再重新開啟 WSL，使用 `free -h` 檢查。

## Q5：為什麼 llama.cpp 編譯時不能直接用 `-j`？

A：單獨使用 `-j` 會依照工具預設開很多 worker，在 16GB Windows RAM + WSL 的環境中容易 OOM。改用 `-j 1` 讓編譯序列化，雖然較慢但穩定。

## Q6：`cp: cannot stat llama.cpp/build/bin/llama-*` 是什麼意思？

A：這代表目標檔案不存在。最常見原因是 build 沒成功，所以 `llama.cpp/build/bin/` 裡沒有符合 `llama-*` 的執行檔。要先回頭檢查 CMake/build log。

## Q7：只編出 `llama-server` 可以嗎？

A：可以。OpenClaw 只需要連到 OpenAI-compatible HTTP endpoint，因此只要 `llama-server` 可執行並正常提供 `/v1` API，就不一定需要其他 llama.cpp CLI 工具。

## Q8：為什麼不用 8000 或 8001 port？

A：8000 / 8001 已被 `docker-proxy` 佔用，因此改用 `18000`，避免和 Docker 或其他服務衝突。

## Q9：OpenClaw 還指到 `local-nemotron`，這樣對嗎？

A：不對。`local-nemotron` 是舊 endpoint。Qwen3.6 的正確 local endpoint 是 `http://127.0.0.1:18000/v1`，model id 使用 `unsloth/Qwen3.6-35B-A3B-GGUF`。

## Q10：Q4_K_M 在 RTX 3090 上一定跑得起來嗎？

A：不一定。RTX 3090 有 24GB VRAM，但 Qwen3.6-35B-A3B 的 Q4_K_M 仍可能 CUDA OOM，尤其在 context size 太大或 GPU layers 太多時。

## Q11：如果 Q4_K_M CUDA OOM，怎麼辦？

A：可依序嘗試：

1. 降低 `--ctx-size`，例如從 8192 降到 4096 或 2048。
2. 限制 `--n-gpu-layers`，不要把所有 layer 都 offload 到 GPU。
3. 改用更小的量化，例如 Q3。
4. 關閉其他佔用 VRAM 的程式，確認 `nvidia-smi`。
