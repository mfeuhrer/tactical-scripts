# Define Software Name
$software = "Action1 Agent"

# Send a $true if software is expected to be installed, $false if not.
# I use {{client.enable_action1}}
$enable_action1 = $args[0]
if($false -eq $enable_action1) {
    Write-Host "[Info] Action1 is not configured for this environment."
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