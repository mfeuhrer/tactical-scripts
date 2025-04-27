function Test-Chocolatey {
    $chocoExePath = "$env:PROGRAMDATA\chocolatey\choco.exe"
    if (-not (Test-Path $chocoExePath)) {
        Write-Host "Chocolatey is not installed."
        return $false
    } else {
        return $true
    }
}
function Get-ChocoPackage {
    # Search for a specific installed software.
    param (
        $searchName
    )
    $packages = @()
    $list = & choco list
    ForEach ($line in $list) {
        $skip = $false
        if ($line.Length -eq 0) {$skip = $true}
        if ($line.Contains("package")) {$skip = $true}
        if ($line.Contains("Did you know")) {$skip = $true}
        if ($line.Contains("Features?")) {$skip = $true}
        if ($line.Contains("https://chocolatey.org/compare")) {$skip = $true}
        if ($skip -ne $true) {
            # Write-Host "Package $($line) is installed."
            $package = New-Object -TypeName psobject
            $package | Add-Member -NotePropertyName chocoName -NotePropertyValue $line.Split( )[0]
            $package | Add-Member -NotePropertyName version -NotePropertyValue $line.Split( )[1]
            $packages += $package
        }
    }
    if ($searchName) {
        # Write-Host "[Info] $($searchName) invoked."
        $searchPackages = @()
        $packages | ForEach-Object {
            if ($_.chocoName.contains($searchName)) {
                # Write-Host "$($_.chocoName) $($_.version) was found in chocolatey."
                # Write-Host "Package $($line) is installed."
                $package = New-Object -TypeName psobject
                $package | Add-Member -NotePropertyName chocoName -NotePropertyValue $_.chocoName
                $package | Add-Member -NotePropertyName version -NotePropertyValue $_.version
                $searchPackages += $package   
            }
            
        }
        if ($searchPackages.count -lt 1) {
                # Write-Host "$($searchName) not managed by chocolatey on this system."
                exit
            } else {
                return $searchPackages
            }
    }
    return $packages
}
# First, check to see if it's found in chocolatey. But to do so, we'll need to make sure we have chocolatey :)
if (!(Test-Chocolatey)) {
    Write-Host "[Fail] Chocolatey binary not found."
    exit 1
}

(Get-ChocoPackage).chocoName