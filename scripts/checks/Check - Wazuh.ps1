# Define Software Name
$software = "Wazuh Agent"

# Search the registry for the software name.
{{Get-Software}}

If((Get-Software $software) -eq $false) {
    Write-Host "[Success] $($software) is not installed."
    exit 0
} else {
    Write-Host "[Fail] $($software) is installed."
    exit 1
}