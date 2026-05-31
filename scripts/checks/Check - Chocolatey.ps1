{{Choco-Module}}

if (-not (Test-Chocolatey)) {
    Write-Host "[Fail] Chocolatey is not installed."
    exit 1
} else {
    Write-Host "[Success] Chocolatey is installed."
    exit 0
}