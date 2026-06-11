# Get feature presence

$server = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

# Check if feature is present and exit successfully if found
if ($server.State -eq 'Installed') {
    Write-Host "[Success] OpenSSH Server Feature is installed."
    exit 0
} elseif ($null -eq $server) {
    Write-Host "[Warn] OpenSSH Server Feature is not found on this system."
    $host.SetShouldExit(2)
    exit
} else {
    Write-Host "[Fail] OpenSSH Server Feature is not installed."
    $host.SetShouldExit(1)
    exit
}