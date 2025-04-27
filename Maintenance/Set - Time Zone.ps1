if ($args) {
    $testZone = $args[0]
} else {
    Write-Host "[Fail] No time zone was provided."
    exit 2
}

# check that the time zone is valid
$desiredZone = Get-TimeZone -ListAvailable | Where-Object { $_.id -eq $testZone}
if ($desiredZone) {
    Write-Host "[Info] $($desiredZone.Id) found on system. "
} else {
    Write-Host "[Fail] Unable to locate a valid time zone with the name $($testZone)."
    exit 2
}

# set it!
try {
    Set-TimeZone $desiredZone
    Write-Host "[Success] Time zone has been set to $($desiredZone.Id), with an offset of $($desiredZone.BaseUtcOffset) "
    exit 0
}
catch {
    Write-Host "[Fail] Time zone failed to update."
    exit 1
}