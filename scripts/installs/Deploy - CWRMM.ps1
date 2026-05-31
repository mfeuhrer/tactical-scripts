# Send the uri as the first argument.
# I use a client variable in tactical for this: {{client.cwrmm_installer}}
if ($false -eq $args) {
    Write-Host "[Fail] No arguments received."
    exit 1
}
$uri = $args[0]
if($false -eq $uri) {
    Write-Host "[Fail] No URL provided. Script will not continue."
    exit 1
}
# Send the token as the second argument.
# I use a client variable in tactical for this: {{client.cwrmm_token}}
$token = $args[1]
if($false -eq $token) {
    Write-Host "[Fail] No token provided. Script will not continue."
    exit 1
}

# Import Snippet
{{Get-Software}}

$check = Get-Software
if ($check -eq 1) {
    Write-Host "[Info] $($software) is not installed, we will attempt the install now."
    Invoke-WebRequest -Uri $uri -OutFile rmm-agent.msi; ./rmm-agent.msi TOKEN=$token /q
    $checkagain = Get-Install
    if ($checkagain -eq 1) {
        Write-Host "[Fail] Installation was not successful"
        exit 1
    } else {
        Write-Host "[Success] Installation was successful"
        exit 0
    }
} else {
    Write-Host "[Info] $($software) is already installed"
    exit 0
}