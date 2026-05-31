# define desired time zone
if ($args) {
    $testZone = $args[0]
} else {
    Write-Host "[Info] No time zone was provided."
    exit 0
}

# check that the time zone is valid
$desiredZone = Get-TimeZone -ListAvailable | Where-Object { $_.id -eq $testZone}
if ($desiredZone) {
    Write-Host "[Info] $($desiredZone.Id) found on system. "
} else {
    Write-Host "[Fail] Unable to locate a valid time zone with the name $($testZone)."
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