{{Choco-Module}}

if (-not (Test-Chocolatey)) {
    Write-Host "[Fail] Chocolatey is not installed."
    exit 1
} else {
    Invoke-Command -ScriptBlock { & choco upgrade all -y } -ErrorAction SilentlyContinue
}