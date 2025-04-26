# Set the name of the software found as shown in the registry. This typically matches appwiz.cpl value.
$software = "Check MK Agent 2.2"

# Send the uri as the first argument.
# I use a client variable in tactical for this: {{client.omd_host}}
$omd_host = $args[0]
if($null -eq $omd_host) {
    Write-Host "[Fail] No check_mk host provided."
    exit 1
}
# Send the site as the second argument.
# I use a client variable in tactical for this: {{client.omd_site}}
$omd_site = $args[1]
if($null -eq $omd_site) {
    Write-Host "[Fail] No check_mk site provided."
    exit 1
    }

$install_url = "https://$($omd_host)/$($omd_site)/check_mk/agents/windows/check_mk_agent.msi"
Write-Host "[Info] Installer url is: $($install_url)"

$logname = "check_mk_install.log"

# Import Snippet
{{Get-Software}}

# Search the registry for the software name entered above.
if ((Get-Software $software) -eq $false) {
    Write-Host "[Info] $($software) is not installed, attempting to install."

    # Validate support folders
    {{Working-Directories}}

    # Put installation process here
    Invoke-WebRequest -Uri $install_url -OutFile dynamic_installer.msi

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