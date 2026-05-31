$AllResources = Get-ClusterResource
$failures = 0
ForEach ($ThisResource in $AllResources)
{
$ThisRC = $ThisResource.Name
$ThisRCS = $ThisResource.State
IF ($ThisRCS -ne "Online")
{
Write-Host "[Warn] Cluster Resource $ThisRC is NOT ONLINE"
$failures = $failures + 1
}
}
If ($failures -eq 0) {
    Write-Host '[Infp] All Cluster Resources are Online.'
    exit 0
} elseif ($faiulres -eq 1) {
    Write-Host $failures + "[Fail] Cluster Resource is not Online and needs attention."
    exit $failures
} else {
    Write-Host $failures + "[Fail] Cluster Resources are not Online and need attention."
    exit $failures
}