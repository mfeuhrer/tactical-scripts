$service = Get-Service -Name LTService
if($service) {
	Write-Host "[Fail] Labtech Agent is installed."
    exit 1
} else {
    Write-Host "[Success] Labtech Agent is not installed."
    exit 0
}