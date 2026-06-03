param(
    # Send $true or $false to -enable_omd. This allows you to disable check_mk installation for specific clients if needed.
    # I use a client level custom field called enable_omd for this: {{client.enable_omd}}
    [bool]$enable_omd,
    # Send the host fqdn to -omd_host. No https:// or trailing slash.
    # I use a client variable in tactical for this: {{client.omd_host}}
    [string]$omd_host
)
# The full argument chain would look like this:
# -enable_omd {{client.enable_omd}} -omd_host {{client.omd_host}}

# Admin defined variables
if($false -eq $enable_omd) {
    Write-Host "[Info] Check_MK is not configured for this environment."
    $host.SetShouldExit(3)
    exit 0
}

if($null -eq $omd_host) {
    Write-Host "[Fail] No check_mk host provided."
    exit 1
}

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
    if ($output.connections.site_id -match $omd_host) {
        Write-Host "[Success] Registered to $($omd_host)"
        exit 0
    }
    Write-Host "[Warn] Check_mk is registered, but is not connected to $($omd_host)"
    $host.SetShouldExit(2)
    exit
}