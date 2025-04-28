# packageName should be the choco name of the sofware.
$packageName = "openssh"

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
    & $chocoExePath uninstall --package-parameters=/SSHServerFeature $packageName -y
    if ((Get-ChocoPackage $packageName)) {
        Write-Host "[Fail] $($packageName) still found in chocolatey. Removal unsuccessful."
        exit 1
    } else {
        Write-Host "[Success] $($packageName) removal complete."
        exit 0
    }
}