<# 
This script is a short hand for getting fqdn for domain joined machines to help match names in various monotoring systems.
#>
$fqdn = (Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Domain).domain
$ComputerName = $env:COMPUTERNAME.ToLower()+"."+$fqdn
return $ComputerName