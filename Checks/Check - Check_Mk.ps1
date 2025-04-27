# Define Software Name
$software = "Check MK Agent 2.2"

# Send a $true if software is expected to be installed, $false if not.
# I use {{client.enable_omd}}
$enable_omd = $args[0]
if($false -eq $enable_omd) {
    Write-Host "[Info] Check_MK is not configured for this environment."
    $host.SetShouldExit(3)
    exit
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