# These functions can be used to call chocolatey from a system where it is installed.
# This is a partial attempt at turning chocolatey CLI into an object based system.

$chocoExePath = "$env:PROGRAMDATA\chocolatey\choco.exe"
function Test-Chocolatey {
    if (-not (Test-Path $chocoExePath)) {
        # Write-Host "[Fail] Chocolatey is not installed."
        return $false
    } else {
        try {
            $choco = & $chocoExePath
        }
        catch {
            # Write-Host "[Fail] Chocolatey is not a recognized command."
            return $false
        }
        # Write-Host "[Success] Chocolatey is responding."
        return $true
    }
}
function Get-ChocoPackage {
    # Search for a specific installed software.
    param (
        $searchName,
        $outdated
    )
    if ($outdated) {
        $staleList = & $chocoExePath outdated
        $stalePackages = @()
        ForEach ($line in $staleList) {
            $skip = $false
            # These are lines choco will print that we don't care about.
            if ($line.Length -eq 0) {$skip = $true}
            if ($line.Contains("Chocolatey")) {$skip = $true}
            if ($line.Contains("Outdated")) {$skip = $true}
            if ($line.Contains("package")) {$skip = $true}
            if ($line.Contains("Did you know")) {$skip = $true}
            if ($line.Contains("experience to the next level at")) {$skip = $true}
            if ($line.Contains("go into bettering")) {$skip = $true}
            if ($line.Contains("nets you some")) {$skip = $true}
            if ($line.Contains("Features?")) {$skip = $true}
            if ($line.Contains("https://chocolatey.org/compare")) {$skip = $true}
            # If no reason to skip, add the line to the collection, splitting name from version based on the space character.
            if ($skip -ne $true) {
                $stalePackage = New-Object -TypeName psobject
                $stalePackage | Add-Member -NotePropertyName chocoName -NotePropertyValue $line.Split("|")[0]
                $stalePackage | Add-Member -NotePropertyName currentVersion -NotePropertyValue $line.Split("|")[1]
                $stalePackage | Add-Member -NotePropertyName availableVersion -NotePropertyValue $line.Split("|")[2]
                $stalePackages += $stalePackage
            }
        }
        if ($stalePackages) {
            return $stalePackages
        } else {
            return $false
        }
    }
    # Refresh the list of locally installed packages
    $chocoList = & $chocoExePath list
    # Turn the text into an object
    $chocoPackages = @()
    ForEach ($line in $chocoList) {
        $skip = $false
        # These are lines choco will print that we don't care about.
        if ($line.Length -eq 0) {$skip = $true}
        if ($line.Contains("Chocolatey")) {$skip = $true}
        if ($line.Contains("Outdated")) {$skip = $true}
        if ($line.Contains("package")) {$skip = $true}
        if ($line.Contains("Did you know")) {$skip = $true}
        if ($line.Contains("experience to the next level at")) {$skip = $true}
        if ($line.Contains("go into bettering")) {$skip = $true}
        if ($line.Contains("nets you some")) {$skip = $true}
        if ($line.Contains("Features?")) {$skip = $true}
        if ($line.Contains("https://chocolatey.org/compare")) {$skip = $true}
        # If no reason to skip, add the line to the collection, splitting name from version based on the space character.
        if ($skip -ne $true) {
            $chocoPackage = New-Object -TypeName psobject
            $chocoPackage | Add-Member -NotePropertyName chocoName -NotePropertyValue $line.Split( )[0]
            $chocoPackage | Add-Member -NotePropertyName version -NotePropertyValue $line.Split( )[1]
            $chocoPackages += $chocoPackage
        }
    }
    if ($searchName) {
        # Write-Host "[Info] Searching for: $($searchName)"
        $searchPackages = @()
        $chocoPackages | ForEach-Object {
            if ($_.chocoName.contains($searchName)) {
                $package = New-Object -TypeName psobject
                $package | Add-Member -NotePropertyName chocoName -NotePropertyValue $_.chocoName
                $package | Add-Member -NotePropertyName version -NotePropertyValue $_.version
                $searchPackages += $package   
            }
            
        }
        if ($searchPackages.count -lt 1) {
                # Write-Host "[Info] $($searchName) is not managed by chocolatey on this system."
                return $false
            } else {
                return $searchPackages
            }
    } else {
        return $chocoPackages
    }
}
