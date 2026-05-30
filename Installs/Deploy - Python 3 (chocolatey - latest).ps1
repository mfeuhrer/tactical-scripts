# packageName should be the choco name of the sofware.
$packageName = "python3"

{{Choco-Module}}

if (-not (Test-Chocolatey)) {
    Write-Host "[Fail] Chocolatey is not installed."
    $host.SetShouldExit(1)
    exit
}

if ((Get-ChocoPackage $packageName) -eq $false) {
    Write-Host "[Info] $($packageName) is not installed, attempting chocolatey installation."
    & $chocoExePath uninstall $packageName -y

    if ((Get-ChocoPackage $packageName)) {
        Write-Host "[Success] $($packageName) is installed."
        exit 0
    } else {
        Write-Host "[Fail] $($packageName) installation failed."
        $host.SetShouldExit(1)
        exit
    }
} else {
    Write-Host "[Success] $($packageName) is already installed."
    exit 0
}