<#
    .SYNOPSIS
    Check Windows activation status
    .DESCRIPTION
    This script checks the Windows activation status by running the "slmgr.vbs" script and returning the results. If the Windows version is activated, the script returns success (exit code 0), otherwise it returns failure (exit code 1).
    .OUTPUTS
    This cmdlet outputs a message indicating whether Windows is activated or not.
    .NOTES
    Version: 1.0 7/17/2021 silversword
    Version: 1.1 7/6/2024 kungfeuhrer
#>

$WinVerAct = (cscript /Nologo "C:\Windows\System32\slmgr.vbs" /xpr) -join ""

if ($WinVerAct -like "*Activated*") {
    Write-Host "[Success] All looks fine $WinVerAct"
    exit 0
}
if ($WinVerAct -like "*will expire*") {
    $WinProduct = Get-ComputerInfo
    Write-Host "[Info] Detected $($WinProduct.WindowsProductName)"
    Write-Host $WinVerAct
    $expiry = [datetime]$WinVerAct.Substring(69,9)
    Write-Host "[Warn] Windows expires on $($expiry.date)"
    $diff = $expiry.date - (Get-Date).Date
    if ($diff.TotalDays -lt 30) {
        Write-Host "[Warn] License will expire in less than 30 days."
        $host.SetShouldExit(2)
        exit
    } elseif ($diff.TotalDays -lt 10) {
        Write-Host "[Fail] License will expire in less than 10 days! Renew Now!"
        exit 1
    }
    Write-Host "[Success] License is activated."
    exit 0
}
else {
    Write-Host "[Fail] There's an issue $WinVerAct"
    exit 1
}