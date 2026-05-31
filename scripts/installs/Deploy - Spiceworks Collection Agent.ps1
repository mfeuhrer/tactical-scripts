$software = "Agent Shell"

# Where to download installer
$site_key = $args[0]
if ($false -eq $site_key) {
    Write-Host "[Fail] No site key provided."
    exit 1
}

$logname = "spiceworks_install.log"

# Import Snippet
{{Get-Software}}

$check = Get-Software
if ($check -eq 0) {

    Write-Host "[Info] $($software) is not installed, we will attempt the install now."
    
    # Validate support folders
    {{Working-Directories}}

    $msiArgs = "/qn /l*v $($logfile) SITE_KEY=$($site_key)"

    Start-BitsTransfer -Source https://download.spiceworks.com/SpiceworksAgent/2.1.0/SpiceworksAgentShell_Collection_Agent.msi -Destination dynamic_installer.msi

    # Check if the installer was downloaded successfully.
    if (-Not (Test-Path -Path dynamic_installer.msi)) {
        Write-Host "[Fail] Installer was not downloaded."
        exit 1
    }

    $dynamicString = "/i dynamic_installer.msi $($msiArgs)"
    Start-Process msiexec.exe $dynamicString -Wait
    
    Start-Sleep -Seconds 120
    $checkagain = Get-Software
    
    if ($checkagain -eq 0) {
        Write-Host '[Fail] Installation was not successful'
        exit 1
    } else {
        Write-Host '[Success] Installation was successful'
        exit 0
    }
} else {
    Write-Host $software '[Info] is already installed'
    exit 0
}