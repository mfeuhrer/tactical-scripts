$chocoExePath = "$env:PROGRAMDATA\chocolatey\choco.exe"

if (-not (Test-Path $chocoExePath)) {
    Write-Host "[Info] Chocolatey is not installed."
    # Trust
    Write-Host "[Info] Installing chocolatey from https://community.chocolatey.org/install.ps1"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-WebRequest https://community.chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
    
    if (-not (Test-Path $chocoExePath)) {
        Write-Host "[Fail] Chocolatey is still not installed."
    eExit 1
    } else {
        Write-Host "[Success] Chocolatey is installed."
        exit 0
    }
} else {
    Write-Host "[Info] Chocolatey is already installed."
    exit 0
}