# Get feature presence

$server = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

# Check if feature is present and exit successfully if found
if ($server.State -eq 'Installed') {
    Write-Host "[Success] OpenSSH Server Feature is already installed."
    exit 0
} elseif ($null -eq $server) {
    Write-Host "[Warn] OpenSSH Server Feature is not available to install on this system."
    $host.SetShouldExit(2)
    exit
} else {
    Write-Host "[Info] Attempting to install OpenSSH Server Feature."
    try {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    } catch {
        Write-Host "[Error] Failed to install OpenSSH Server Feature. $_"
        $host.SetShouldExit(1)
        exit
    }
    try {
        Set-Service -Name sshd -StartupType 'Automatic'
    } catch {
        Write-Host "[Error] Failed to set sshd service startup type. $_"
        $host.SetShouldExit(1)
        exit
    }
    Start-Service sshd
    Write-Host "[Success] OpenSSH Server Feature has been installed and started."
    exit
}
