# Writes a conservative WSL configuration for a Windows host with 16GB RAM.
# Run this from Windows PowerShell, then execute: wsl --shutdown

$ConfigPath = Join-Path $env:USERPROFILE ".wslconfig"
$BackupPath = "$ConfigPath.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"

if (Test-Path $ConfigPath) {
    Copy-Item $ConfigPath $BackupPath -Force
    Write-Host "Backed up existing .wslconfig to $BackupPath"
}

@"
[wsl2]
memory=15GB
swap=32GB
localhostForwarding=true
"@ | Set-Content -Path $ConfigPath -Encoding ASCII

Write-Host "Wrote $ConfigPath"
Write-Host "Run: wsl --shutdown"
Write-Host "Then reopen WSL and check: free -h"
