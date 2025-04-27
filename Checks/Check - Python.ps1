$software = "Python Launcher";

# Import Snippet
{{Get-Software}}

$check = Get-Software
if ($check -eq 1) {
    Write-Host "[Fail] $($software) is not installed."
    exit 1
} else {
    Write-Host "[Success] $($software) is installed."
    exit 0
}