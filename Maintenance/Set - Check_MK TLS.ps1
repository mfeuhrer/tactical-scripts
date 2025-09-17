# Software to configure
$software = "Checkmk Agent 2.4"

# Required variables for script execution

# Admin defined
$omd_site = $args[0]
if($false -eq $omd_site) {
    Write-Host "[Fail] No check_mk site provided."
    exit 1
    }
$omd_host = $args[1]
if($false -eq $omd_host) {
    Write-Host "[Fail] No check_mk host provided."
    exit 1
}
$omd_user = $args[2]
if($false -eq $omd_user) {
    Write-Host "[Fail] No check_mk user provided."
    exit 1
}
$omd_token = $args[3]
if($false -eq $omd_token) {
    Write-Host "[Fail] No check_mk user token provided."
    exit 1
}

# Detected
$fqdn = (Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Domain).domain
$ComputerName = $env:COMPUTERNAME.ToLower()+"."+$fqdn


# Functions
function Get-Install {
    $installed = $null -ne (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $software })

    If(-Not $installed) {
        return 1
    } else {
        return 0
    }
}
function Set-Registration {
    $cmdPath = "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe"
    $cmdArgList = @(
        "register",
        "--trust-cert",
        "--server", $omd_host,
        "--site", $omd_site,
        "--hostname", "$($ComputerName)",
        "--user", $omd_user,
        "--password", $omd_token
        )
    $execStats = Measure-Command {& $cmdPath $cmdArgList}
    Write-Host "[Success] registration completed in $($execStats) seconds."    
}

$check = Get-Install
if ($check -eq 1) {
    Write-Host "[Fail] $($software) is not installed."
    exit 1
} else {
    Write-Host "[Info] $($software) is already installed, register with server."
    Set-Registration
    exit 0
}