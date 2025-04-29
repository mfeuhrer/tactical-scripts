# packageName should be the choco name of the sofware.
$packageName = "python312"

{{Choco-Module}}

if (-not (Test-Chocolatey)) {
    Write-Host "[Fail] Chocolatey is not installed."
    exit 1
}

if ((Get-ChocoPackage $packageName) -eq $false) {
    Write-Host "[Success] $($packageName) is not installed."
    exit 0
} else {
    Write-Host "[Fail] $($packageName) found in chocolatey."
    exit 2
}