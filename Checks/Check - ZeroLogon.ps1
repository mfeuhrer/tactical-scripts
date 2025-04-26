 if ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\ -Name "FullSecureChannelProtection") -eq 1) {
    Write-Host "[Success] Secure Netlogon Channels Enforced"
    exit 0
 } else {
     Write-Host "[Warn] Secure Netlogon only enforced for Windows endpoints."
    exit 1
 }