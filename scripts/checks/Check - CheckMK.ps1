param(
    # Send agent version to -omd_agent_version. This allows different sites to maintain different versions. Server's highest version will be used if not specified.
    # I use a client level custom field called omd_agent_version for this: {{client.omd_agent_version}}
    [string]$omd_agent_version,
    # Send $true or $false to -enable_omd. This allows you to disable check_mk installation for specific clients if needed.
    # I use a client level custom field called enable_omd for this: {{client.enable_omd}}
    [bool]$enable_omd
)
# The full argument chain would look like this:
# -enable_omd {{client.enable_omd}} -omd_agent_version {{client.omd_agent_version}}

# Set the name of the software found as shown in the registry. This typically matches appwiz.cpl value.
if($omd_agent_version) {
    $software = "Checkmk Agent $($omd_agent_version)"
} else {
    $software = "Checkmk Agent 2.5"
}

if($false -eq $enable_omd) {
    Write-Host "[Info] Check_MK is not configured for this environment."
    $host.SetShouldExit(3)
    exit 0
}

# Import Snippet
{{Get-Software}}

If((Get-Software $software) -eq $false) {
    Write-Host "[Fail] $($software) is not installed."
    exit 1
} else {
    Write-Host "[Success] $($software) is installed."
    exit 0
}