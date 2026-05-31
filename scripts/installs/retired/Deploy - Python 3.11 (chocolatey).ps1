$software = "Python Launcher";
# packageName should be the choco name of the sofware.
$packageName = "python311"
function Check-Install {
    $installed = $null -ne (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $software })

    If(-Not $installed) {
        return 1
    } else {
        return 0
    }
}

$check = Check-Install
if ($check -eq 1) {
    Write-Host $software 'is not installed, we will attempt the install now'
    $chocoExePath = "$env:PROGRAMDATA\chocolatey\choco.exe"
    if (-not (Test-Path $chocoExePath)) {
        Write-Output "Chocolatey is not installed."
        Exit 1
    }
    $wait = Get-Random -Maximum 420
    Start-Sleep -Seconds $wait
    & $chocoExePath install $packageName -y
    # Start-Sleep -Seconds 30
    $checkagain = Check-Install
    if ($checkagain -eq 1) {
        Write-Host 'Installation was not successful.'
        exit 1
    } else {
        Write-Host 'Installation was successful.'
        exit 0
    }
} else {
    Write-Host $software 'is already installed.'
    exit 0
}