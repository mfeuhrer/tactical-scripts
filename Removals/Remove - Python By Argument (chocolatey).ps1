# This script accepts one argument, a python package name as it exists in chocolatey.
# For example, python 3.11 would be installed as python311

$packageName = $args[0]
if($false -eq $packageName) {
    Write-Host "[Info] Check_MK is not configured for this environment."
    $host.SetShouldExit(3)
    exit 0
}

{{Choco-Module}}

if (-not (Test-Chocolatey)) {
    Write-Host "[Fail] Chocolatey is not installed."
    exit 1
}

if ((Get-ChocoPackage $packageName) -eq $false) {
    Write-Host "[Success] $($packageName) is not installed."
    exit 0
} else {
    Write-Host "[Info] $($packageName) is installed, attempting removal."
    & $chocoExePath uninstall $packageName -y
    if ((Get-ChocoPackage $packageName)) {
        Write-Host "[Fail] $($packageName) still found in chocolatey. Removal unsuccessful."
        exit 1
    } else {
        Write-Host "[Success] $($packageName) removal complete."
        exit 0
    }
}