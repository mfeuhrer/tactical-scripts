# Obliterate registered_connections.json file to reset TLS settings for CheckMK
# This file is located at: C:\ProgramData\checkmk\agent\registered_connections.json

try {
    Remove-Item -Path "C:\ProgramData\checkmk\agent\registered_connections.json" -ErrorAction SilentlyContinue
    Write-Host "[Success] TLS settings reset successfully."
    exit 0
} catch {
    Write-Host "[Fail] Failed to reset TLS settings: $_"
    exit 1
}