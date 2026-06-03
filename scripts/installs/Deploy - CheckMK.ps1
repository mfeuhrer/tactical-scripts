param(
    # Send agent version to -omd_agent_version. This allows different sites to maintain different versions. Server's highest version will be used if not specified.
    # I use a client level custom field called omd_agent_version for this: {{client.omd_agent_version}}
    [string]$omd_agent_version,
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
# -omd_agent_version {{client.omd_agent_version}} -enable_omd {{client.enable_omd}} -omd_host {{client.omd_host}} -omd_site {{client.omd_site}}

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

if($false -eq $omd_host) {
    Write-Host "[Fail] No check_mk host provided."
    exit 1
}

if($false -eq $omd_site) {
    Write-Host "[Fail] No check_mk site provided."
    exit 1
    }

$install_url = "https://$($omd_host)/$($omd_site)/check_mk/agents/windows/check_mk_agent.msi"
Write-Host "[Info] Installer url is: $($install_url)"

$logname = "check_mk_update.log"

# Import Snippet
{{Get-Software}}

# Search the registry for the software name entered above.
if ((Get-Software $software) -eq $false) {
    Write-Host "[Info] $($software) is not installed, attempting to install."

    # Validate support folders
    {{Working-Directories}}

    # Put installation process here
    Start-BitsTransfer -Source $install_url -Destination dynamic_installer.msi

    # Check if the installer was downloaded successfully.
    if (-Not (Test-Path -Path dynamic_installer.msi)) {
        Write-Host "[Fail] Installer was not downloaded."
        exit 1
    }

    # Assemble install command
    $msiArgs = "/qn /passive /l*v $($logfile)"
    $dynamicString = "/i dynamic_installer.msi $($msiArgs)"
    Start-Process msiexec.exe $dynamicString -Wait

    # Remove the installer.
    Remove-Item ./dynamic_installer.MSI

    # Wait 10 seconds for install to complete
    Start-Sleep -Seconds 10

    # By default, check again to see if software is now installed. 
    # If additional configuration tasks are required to confirm a successful installation, modify the check condition to suit.
    if ((Get-Software $software) -eq $false) {
        Write-Host "[Fail] Installation was not successful."
        exit 1
    } else {
        Write-Host "[Success] Installation was successful."
        exit 0
    }
} else {
    Write-Host "[Info] $($software) is already installed."
    exit 0
}