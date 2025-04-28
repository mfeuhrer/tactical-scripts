# Setup environment

$logname = "Duplicati_logging_install.log"

{{Working-Directories}}

$before_file = $scriptdir + "duplicati_before.bat"
$after_file = $scriptdir + "duplicati_after.bat"

$before_uri = "https://blob.omicr0n.cloud/Resources/duplicati_before.bat"
$after_uri = "https://blob.omicr0n.cloud/Resources/duplicati_after.bat"

# Check if the files already exist.

if (-Not (Test-Path -Path $before_file)) {
    # Download the file if it doesn't exist.
    Write-Host "[Info] Downloading $($before_file)."
    Start-BitsTransfer -Source $before_uri -Destination $before_file
} else {
    Write-Host "[Info] File already exists: $($before_file)."
}

if (-Not (Test-Path -Path $after_file)) {
    # Download the file if it doesn't exist.
    Write-Host "[Info] Downloading $($after_file)."
    Start-BitsTransfer -Source $after_uri -Destination $after_file
} else {
    Write-Host "[Info] File already exists: $($after_file)."
}

if (-Not (Test-Path -Path $before_file)) {
    Write-Host "[Fail] $($before_file) could not be downloaded."
    exit 1
} else {
    Write-Host "[Success] $($before_file) installed successfully."
}
if (-Not (Test-Path -Path $after_file)) {
        Write-Host "[Fail] $($after_file) could not be downloaded."
        exit 1
} else {
    Write-Host "[Success] $($after_file) installed successfully."
}