# Set to your KMS server

$kms_host = $args[0]
if ($false -eq $kms_host) {
    Write-Host "[Info] No KMS server provided."
    $host.SetShouldExit(3)
    exit
}

$installed = $null -ne (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" | Where-Object { $_.KeyManagementServiceName -eq $kms_host })

If(-Not $installed) {
    Write-Host "[Fail] $($kms_host) is not set as the preferred activation server."
    exit 1
} else {
    Write-Host "[Success] $($kms_host) is set as the preferred activation server."
    exit 0
}