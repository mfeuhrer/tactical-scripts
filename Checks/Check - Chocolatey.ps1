$chocoExePath = "$env:PROGRAMDATA\chocolatey\choco.exe"

if (-not (Test-Path $chocoExePath)) {
    Write-Host "[Fail] Chocolatey is not installed."
    exit 1
} else {
    Write-Host "[Success] Chocolatey is installed."
    exit 0
}