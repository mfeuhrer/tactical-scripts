# Define Software Name
$software = ""

# Import Snippet
{{Get-Software}}

If((Get-Software $software) -eq $false) {
    Write-Host "[Fail] $($software) is not installed."
    exit 1
} else {
    Write-Host "[Success] $($software) is installed."
    exit 0
}