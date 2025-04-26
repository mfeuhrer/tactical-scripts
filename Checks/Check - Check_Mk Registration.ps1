# Admin defined variables
# Send a $true if software is expected to be installed, $false if not.
# I use {{client.enable_omd}}
$enable_omd = $args[0]
if($false -eq $enable_omd) {
    Write-Host "[Info] Check_MK is not configured for this environment."
    exit 0
}
# Send the uri as the second argument, do not include http(s)://
# I use a client variable in tactical for this: {{client.omd_host}}
$omd_host = $args[1]
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

$execStats = Measure-Command {$output = & $cmk $cmdArgList | ConvertFrom-Json}
    Write-Host "[Info] Task performed in $($execStats) seconds."  

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
    exit 2
}