# Script can be used to clear out stale downloads that have not been processed.

# Script accepts a single parameter, the number of days to keep downloads for. Any downloads older than this will be deleted.
# Defaults to 60 days if no parameter is provided.
param(
    [int]$daysToKeep = 60
)

# Provide any categories to skip
$categoriesToSkip = @(
    "books",
    "comics",
    "music"
)

# Set the path to the Sabnzbd completed downloads folder
$completedDrive = "F"
$completedTree = "sabnzbd\complete"
$completedDownloadsPath = "$($completedDrive):\$($completedTree)"

# Get the current date and time
$currentDate = Get-Date
# Get the existing drive utilization before cleanup
$drive = Get-PSDrive -Name $completedDrive
# Enumerate each subfolder as a download category
Get-ChildItem -Path $completedDownloadsPath -Directory | Where-Object { $_.Name -notin $categoriesToSkip } | ForEach-Object {
    $categoryPath = $_.FullName
    Write-Host "[INFO] Checking for removable folders for $($categoryPath)."
    # First check for any folders that start with _FAILED_ or _UNPACK_ and remove those immediately, no date check needed
    Get-ChildItem -Path $categoryPath -Directory | Where-Object { $_.Name -like "_FAILED_*" -or $_.Name -like "_UNPACK_*" } | ForEach-Object {
        Write-Host "[INFO] Deleting failed download folder: $($_.FullName)"
        try {
            Remove-Item -LiteralPath $_.FullName -Recurse -Force
            Write-Host "[SUCCESS] Deleted folder: $($_.FullName)"
        } catch {
            Write-Host "[ERROR] Failed to delete folder: $($_.FullName)"
        }
    }
    # Get all files in the category folder
    Write-Host "[INFO] Checking for folders older than $($daysToKeep) days for $($categoryPath)."
    Get-ChildItem -Path $categoryPath -Directory | ForEach-Object {
        $folder = $_
        $folderAge = ($currentDate - $folder.LastWriteTime).TotalDays

        # If the folder is older than the specified number of days, delete it
        if ($folderAge -gt $daysToKeep) {
            Write-Host "[INFO] Deleting folder: $($folder.FullName) (Age: $([math]::Round($folderAge, 2)) days)"
            try {
                Remove-Item -LiteralPath $folder.FullName -Recurse -Force
                Write-Host "[SUCCESS] Deleted folder: $($_.FullName)"
            } catch {
                Write-Host "[ERROR] Failed to delete folder: $($_.FullName)"
            }
        }
    }
}

# Get the drive utilization after cleanup
$driveAfter = Get-PSDrive -Name $completedDrive
$storageFreed = $drive.Used - $driveAfter.Used
Write-Host "[INFO] Cleanup freed $($storageFreed / 1GB) GB of storage space."