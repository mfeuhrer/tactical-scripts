if (get-windowsFeature | Where-Object {($_.installstate -eq "installed") -and ($_.name -eq "SNMP-Service")}) {
    Write-Host "[Info] SNMP is already installed"
    exit 0
} else {
    Write-Host "[Info] SNMP is not installed, we will attempt the install now."
    Install-WindowsFeature -Name SNMP-Service -IncludeManagementTools
    if (get-windowsFeature | Where-Object {($_.installstate -eq "installed") -and ($_.name -eq "SNMP-Service")}) {
        Write-Host "[Success] SNMP was successfully installed"
        exit 0
    } else {
        Write-Host "[Fail] SNMP installation failed"
        exit 1
    }
}