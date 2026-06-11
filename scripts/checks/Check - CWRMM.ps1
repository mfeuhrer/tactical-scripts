# Define Software Name
$software = "ITSPlatform"

# Search the registry for the software name.
{{Get-Software}}

If((Get-Software $software) -eq $false) {
    Write-Host "[Success] $($software) is not installed."
    # exit 0
} else {
    Write-Host "[Fail] ($software) is installed."
    exit 1
}

$SAAZ = Get-Service -Name "SAAZ*" -ErrorAction SilentlyContinue

if ($null -eq $SAAZ) {
    Write-Host "[Success] SAAZ Services not found on this system."
    exit 0
} else {
    Write-Host "[Fail] $($SAAZ.count) SAAZ Service(s) found on this system."
    $SAAZ | ForEach-Object { Write-Host " - $($_.DisplayName)" }
    exit 1
}