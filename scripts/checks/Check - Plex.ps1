$plex = Get-Process -Name "Plex Media Server" -ErrorAction SilentlyContinue
if ($plex) {
    Write-Host "[Success] $($plex.Name) is running!"
    exit 0
} else {
    Write-Host "[Fail] Plex Media Server is not running!"
    exit 1
}