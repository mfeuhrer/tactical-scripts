# Define Software Name
$software = "VMware Tools"

# Import Snippet
{{Get-Software}}

If((Get-Software $software) -eq $false) {
    Write-Host "[Success] $($software) is not installed."
    exit 0
} else {
    Write-Host "[Fail] $($software) is installed."
    exit 1
}