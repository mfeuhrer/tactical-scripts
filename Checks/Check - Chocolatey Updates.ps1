$choco = Get-Command -Name choco.exe -ErrorAction SilentlyContinue

If(!$choco) {
    Write-Host "[Warn] Chocolatey is not installed, exiting with a warning."
    exit 2
}

$outdated = choco outdated
if ($outdated.count -gt 6) {
    Write-Host "[Info] Updates to your chocolatey packages are available!"
    Write-Host "[Info] The following packages can be updated: `n"
    # Write-Host ' '
    $outdatedPackages = @()
    for ($i = 4; $i -lt $outdated.Count-2; $i++) {
            $package = New-Object -TypeName psobject
            $package | Add-Member -NotePropertyName packagename -NotePropertyValue $outdated[$i].Split('|')[0]
            $package | Add-Member -NotePropertyName version -NotePropertyValue $outdated[$i].Split('|')[1]
            $package | Add-Member -NotePropertyName available -NotePropertyValue $outdated[$i].Split('|')[2]
            $outdatedPackages += $package
    }

    foreach ($item in $outdatedPackages) {
        Write-Host "[Info] $($item.packagename) can be upgraded to $($item.available) from $($item.version)"
    }
    exit 1
} else {
    Write-Host "No chocolatey package updates are available"
    exit 0
}