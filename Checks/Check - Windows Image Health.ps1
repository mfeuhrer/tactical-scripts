$health = Repair-WindowsImage -Online -CheckHealth

$string = [string]$health.ImageHealthState

if ($string.contains("Repairable")) {
    Write-Host "[Warn] The Windows Image is in an unhealthy state and can be repaired!"
    $host.SetShouldExit(2)
    exit
}
if ($string.contains("Unhealthy")) {
    Write-Host "[Fail] The Windows Image is in an unhealthy state!"
    return 1
    exit
}
if ($string.contains("Healthy")) {
    Write-Host "[Success] The Windows Image is in a healthy state!"
    exit 0
}