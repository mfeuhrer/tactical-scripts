# Search the registry for the software name.
function Get-Software {
    $x86 = $null -ne (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $software })
    $x64 = $null -ne (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $software })
    
    If($x64) {
        Write-Host "[Info] 64-bit install detected."
        return 1
    } elseif($x86) {
        Write-Host "[Info] 32-bit install detected."
        return 1
    } else {
        Write-Host "[Info] $($software) not found."
        return 0
    }
}