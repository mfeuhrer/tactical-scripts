# Time to have fun. Let's check both the system drive and chocolatey to see if there are traces of older Python installed.

# Define the old versions with an array. 
$oldVersions = ("python2*","python309","python310","python311")

{{Choco-Module}}

if (!$skip) {
    $legacyPackages = @()
    foreach ($item in $oldVersions) {
        $legacyPackage = Get-ChocoPackage -searchName $item.Trim()
        if ($legacyPackage) {
            # Write-Host "[Info] $($legacyPackage.chocoName) managed by chocolatey."
            $legacyPackages += $legacyPackage
        }
    }
    if ($legacyPackages) {
        Write-Host "[Warn] The following EoL versions of python were found in chocolatey:"
        return $legacyPackages
        $host.SetShouldExit(2)
        exit
    } else {
        Write-Host "[Success] No EoL packages found with chocolatey!"
        exit 0
    }
}