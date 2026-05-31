# Set the name of the software found as shown in the registry. This typically matches appwiz.cpl value.
$software = "Action1 Agent"

# Where to download installer
$install_url = $args[0]
if ($false -eq $install_url) {
    Write-Host "[Fail] No install URL provided."
    exit 1
}
$logname = "action1_install.log"


# A function to search through the registry to determine if the system believes the software is installed.
# Return 1 if not found, return 0 if found.

# Import Snippet
{{Get-Software}}

# Search the registry for the software name entered above.
if ((Get-Software $software) -eq $false) {
    Write-Host "[Info] $($software) is not installed, we will attempt the install now."

    # Validate support folders
    {{Working-Directories}}

    $msiArgs = "/qn /passive /l*v $($logfile)"

    # Put installation process here
    # URL leads to dynamic content so BITS doesn't work here.
    Invoke-WebRequest -Uri $install_url -OutFile dynamic_installer.msi

    # Check if the installer was downloaded successfully.
    if (-Not (Test-Path -Path dynamic_installer.msi)) {
        Write-Host "[Fail] Installer was not downloaded."
        exit 1
    }

    $dynamicString = "/i dynamic_installer.msi $($msiArgs)"
    Start-Process msiexec.exe $dynamicString -Wait

    # Remove the installer.
    Remove-Item ./dynamic_installer.MSI

    # Wait 15 seconds for install to complete
    Start-Sleep -Seconds 15
    
    # By default, check again to see if software is now installed. 
    # If additional configuration tasks are required to confirm a successful installation, modify the check condition to suit.
    if ((Get-Software $software) -eq $false) {
        # Things to do if the installation failed.
        Write-Host "[Fail] Installation was not successful"
        exit 1
    } else {
        # Things to do if the installation succeeded.
        Write-Host "[Success] Installation was successful"
        exit 0
    }
} else {
    Write-Host "[Info] $($software) is already installed"
    exit 0
}