# Set the name of the software found as shown in the registry. This typically matches appwiz.cpl value.
$software = "Checkmk Agent 2.4"

# Send a $true if software is expected to be installed, $false if not.
# I use {{client.enable_omd}}
$enable_omd = $args[0]
if($false -eq $enable_omd) {
    Write-Host "[Info] Check_MK is not configured for this environment."
    $host.SetShouldExit(3)
    exit 0
}

# Send the uri as the second argument.
# I use a client variable in tactical for this: {{client.omd_host}}
$omd_host = $args[1]
if($false -eq $omd_host) {
    Write-Host "[Fail] No check_mk host provided."
    exit 1
}
# Send the site as the third argument.
# I use a client variable in tactical for this: {{client.omd_site}}
$omd_site = $args[2]
if($false -eq $omd_site) {
    Write-Host "[Fail] No check_mk site provided."
    exit 1
    }

$base_url = "https://$($omd_host)/$($omd_site)/check_mk/agents/windows/plugins/"
Write-Host "[Info] Base url is: $($base_url)"

$logname = "check_mk_install.log"

# Import Snippet
{{Get-Software}}

# Search the registry for the software name entered above.
if ((Get-Software $software) -eq $true) {
    Write-Host "[Info] $($software) is installed, downloading plugins."

    # Validate support folders
    {{Working-Directories}}

    $plugins = @("win_license.bat", "windows_tasks.ps1", "windows_updates.vbs")
    $errors = @()

    ForEach ($plugin in $plugins) {
        $install_url = "$($base_url)$($plugin)"
        Write-Host "[Info] Downloading plugin: $($install_url)"
        Start-BitsTransfer -Source $install_url -Destination "C:\ProgramData\checkmk\agent\plugins\$($plugin)"

        # Check if the installer was downloaded successfully.
        if (-Not (Test-Path -Path "C:\ProgramData\checkmk\agent\plugins\$($plugin)")) {
            Write-Host "[Fail] Plugin $($plugin) was not downloaded."
            $errors += $plugin
        } else {
            Write-Host "[Success] Plugin $($plugin) was downloaded."
        }
    }

    if ($errors.Count -eq 0) {
        Write-Host "[Success] All plugins downloaded successfully."
        exit 0
    } else {
        Write-Host "[Fail] The following plugins failed to download: $($errors -join ', ')"
        exit 1
    }
    
} else {
    Write-Host "[Info] $($software) is not installed."
    exit 1
}