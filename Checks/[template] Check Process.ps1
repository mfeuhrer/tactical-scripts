# Define the process name you want to watch
$processName = ""

$process = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($process) {
    Write-Host "$($process.Name) is running!"
    exit 0
} else {
    Write-Host "$($processName) is not running!"
    exit 1
}