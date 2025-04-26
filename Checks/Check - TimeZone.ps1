# define desired time zone
if ($args) {
    $testZone = $args[0]
} else {
    Write-Output "[Fail] No time zone was provided."
    Write-Host "[Fail] Script will not continue."
    exit 2
}

# check that the time zone is valid
$desiredZone = Get-TimeZone -ListAvailable | Where-Object { $_.id -eq $testZone}
if ($desiredZone) {
    Write-Host "[Info] $($desiredZone.Id) found on system. "
} else {
    Write-Output "[Fail] Unable to locate a valid time zone with the name $($testZone)."
    Write-Host "[Fail] Script will not continue."
    exit 2
}

# get the current time zone
$currentTZ = Get-TimeZone

# check if they match
if ($currentTZ -eq $desiredZone) {
    Write-Host "[Success] Time zones match!"
    exit 0
} else {
    Write-Host "[Fail] Local time zone is set to $($currentTZ.Id) but $($desiredZone.Id) is expected"
    exit 1
}