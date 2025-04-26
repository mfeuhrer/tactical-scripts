# Define Software Name
$software = "NinjaRMMAgent"

# Search the registry for the software name.
{{Get-Software}}

If((Get-Software $software) -eq $false) {
    Write-Host "[Success] $($software) is not installed."
    exit 0
} else {
    Write-Host "[Info] $($software) is installed."
    exit 1
}