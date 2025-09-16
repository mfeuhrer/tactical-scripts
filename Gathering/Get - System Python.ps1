try {
    $python = Get-Command python
if ($python) {
    Invoke-Command -ScriptBlock { & $python --version}
    # & $python --version
    exit 0
} else {
    Write-Host "[Info] Python is not installed on this system."
    exit 0
}    
}
catch {
    Write-Host "[Error] SYSTEM could not run python.exe."
    exit 1
}