param(
    # Send username to -omd_user. Needs permission to register endpoints
    # I use a client level custom field called omd_agent_version for this: {{client.omd_user}}
    [string]$omd_user,
    # Send user token to -omd_token. This is the token generated for the user in check_mk.
    # I use a client level custom field called omd_agent_version for this: {{client.omd_token}}
    [string]$omd_token,
    # Send $true or $false to -enable_omd. This allows you to disable check_mk installation for specific clients if needed.
    # I use a client level custom field called enable_omd for this: {{client.enable_omd}}
    [bool]$enable_omd,
    # Send the host fqdn to -omd_host. No https:// or trailing slash.
    # I use a client variable in tactical for this: {{client.omd_host}}
    [string]$omd_host,
    # Send the site name in omd to -omd_site. No trailing slash.
    # I use a client variable in tactical for this: {{client.omd_site}}
    [string]$omd_site
)
# The full argument chain would look like this:
# -enable_omd {{client.enable_omd}} -omd_host {{client.omd_host}} -omd_site {{client.omd_site}} -omd_user {{client.omd_user}} -omd_token {{client.omd_token}}

# Set the name of the software found as shown in the registry. This typically matches appwiz.cpl value.
if($omd_agent_version) {
    $software = "Checkmk Agent $($omd_agent_version)"
} else {
    $software = "Checkmk Agent 2.5"
}
# Admin defined
if($false -eq $enable_omd) {
    Write-Host "[Info] Check_MK is not configured for this environment."
    $host.SetShouldExit(3)
    exit 0
}
if($false -eq $omd_site) {
    Write-Host "[Fail] No check_mk site provided."
    exit 1
    }
if($false -eq $omd_host) {
    Write-Host "[Fail] No check_mk host provided."
    exit 1
}
if($false -eq $omd_user) {
    Write-Host "[Fail] No check_mk user provided."
    exit 1
}
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
    Write-Host "[Info] $($software) is installed, register with server."
    Set-Registration
    
    # Check registration status
    # Path to cmk
    $cmk = "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe"
    # Confirm file exists
    if (-Not (Test-Path -Path $cmk)) {
        Write-Host "[Fail] Check_mk agent is not installed!"
        exit 1
    }
    # Arguments to retrieve current configuration status
    $cmdArgList = @(
        "status",
        "--json"
    )

    $output = & $cmk $cmdArgList | ConvertFrom-Json

    if ($output.allow_legacy_pull -eq $true) {
        Write-Host "[Fail] Check_mk is running in legacy mode!"
        exit 1
    } else {
        Write-Host "[Info] Check_mk does not allow legacy connections."
        if ($output.connections.count -lt 1) {
            Write-Host "[Fail] No servers are registered!"
            exit 1
        }
    }
    if ($output.connections.site_id -match $omd_host) {
        Write-Host "[Success] Registered to $($omd_host)"
        exit 0
    }
    Write-Host "[Warn] Check_mk is registered, but is not connected to $($omd_host)"
    $host.SetShouldExit(2)
    exit
}