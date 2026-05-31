{{Choco-Module}}

if (-not (Test-Chocolatey)) {
    Write-Host "[Fail] Chocolatey is not installed."
    exit 1
}

$outdatedPackages = Get-ChocoPackage -outdated $true

if ($outdatedPackages) {
    Write-Host "[Info] $($outdatedPackages.Count) packages are outdated:"
    $outdatedPackages | Format-Table
    # foreach ($item in $outdatedPackages) {
    #     Write-Host "[Info] $($item.packagename) can be upgraded from $($item.version) to $($item.available)"
    # }
    exit 1
} else {
    Write-Host "[Info] All packages up to date!"
    exit 0
}