# Script Methodology

## How do I write scripts?

It's an important question. What even qualifies a script?

Technically, you can save the following to a .ps1 file, and you've got a script

```powershell
Write-Host "This is a script!"
```

It's the old "Hello World" example I learned in school. While that would fit the technical definition of a script (a set of written instructions or text), it's not particularly useful. 

When I'm writing a script, be it for endpoint automation or otherwise, I generally have a task to accomplish. To do so, I try to keep a few guidelines in mind. We can use the [Check_MK TLS Registration](https://git.masonfeuhrer.com/pub/tacticalrmm-scripts/-/blob/eb0a848f8916207f2f4de073683583e7d9cbb3f0/scripts/maintenance/Set%20-%20CheckMK%20TLS.ps1) script as a reference.

### Identify the Need

Before taking action, we really ought to confirm that action is necessary. 

In the check_mk example, we need two things to successfully deploy: Does the endpoint have the agent installed, and is the environment configured for check_mk?

The check_mk information is all retrieved through arguments provided by the RMM tool at runtime. These arguments are pulled from custom fields. 

```js
### Arguments passed via RMM in order
{{lcient.omd_site}} {{client.omd_host}} {{client.omd_user}} {{client.omd_token}}
```

The script then reads those arguments and determines if the check needs to proceed.

```powershell
# Required variables for script execution

# Admin defined
$omd_site = $args[0]

if($false -eq $omd_site) {
    Write-Host "[Fail] No check_mk site provided."
    exit 1
    }

$omd_host = $args[1]

if($false -eq $omd_host) {
    Write-Host "[Fail] No check_mk host provided."
    exit 1
}

$omd_user = $args[2]

if($false -eq $omd_user) {
    Write-Host "[Fail] No check_mk user provided."
    exit 1
}

$omd_token = $args[3]

if($false -eq $omd_token) {
    Write-Host "[Fail] No check_mk user token provided."
    exit 1
}
```

The script then uses a function to check the status of the endpoint software

```powershell
# Functions

function Get-Install {
	$installed = $null -ne (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $software })
    If(-Not $installed) {
        return 1
    } else {
        return 0
    }
}
```
### Check for Road Blocks

Once we've confirmed there's a need to take action, we should check to see if anything would prevent taking action, within reason. 

In this case, the custom fields shown above demonstrate several exit conditions where the script would stop immediately if the appropriate configuration items were not in place. 

The function defined above is then used to determine if the script should exit due to not being installed

```powershell
$check = Get-Install
if ($check -eq 1) {
    Write-Host "[Fail] $($software) is not installed."
    exit 1
}
```

### Take Action

We've established that action is necessary and we've made sure nothing's stopping us. It's time to take action.

The rest of condition above then continues on to attempt registration with the check_mk server

```powershell
$check = Get-Install
if ($check -eq 1) {
    Write-Host "[Fail] $($software) is not installed."
    exit 1
} else {
    Write-Host "[Info] $($software) is already installed, register with server."
    Set-Registration
}
```
### Confirm the Activity

We took action. Check again to make sure the original need has been resolved. 

With the check_mk example, the script can run a command against the check_mk agent that will return registration data for the secure channel. The script will fail if legacy encryption is found and will succeed if the specified check_mk server host is found in the registration.

```powershell
# The following immediately follows Set-Registration in the reference above

# Check registration status
# Path to cmk
$cmk = "C:\Program Files (x86)\checkmk\service\cmk-agent-ctl.exe"
# Confirm file exists
if (-Not (Test-Path -Path $cmk)) {
	Write-Host "[Fail] Check_mk agent is not installed!"
	exit 1
}
# Arguments to retrieve current configuration status
$cmdArgList = @(
	"status",
	"--json"
)
$output = & $cmk $cmdArgList | ConvertFrom-Json

if ($output.allow_legacy_pull -eq $true) {
	Write-Host "[Fail] Check_mk is running in legacy mode!"
	exit 1
} else {
	Write-Host "[Info] Check_mk does not allow legacy connections."
	if ($output.connections.count -lt 1) {
	    Write-Host "[Fail] No servers are registered!"
	    exit 1
	}
}
if ($output.connections.site_id -match $omd_host) {
	Write-Host "[Success] Registered to $($omd_host)"
	exit 0
}
Write-Host "[Warn] Check_mk is registered, but is not connected to $($omd_host)"
$host.SetShouldExit(2)
exit
```

### Cleanup

While the above script requires no cleanup, it is important that once an activity has been confirmed, any temporary artifacts are removed. 

If an installer was downloaded, delete it after the application is installed. If an archive was extracted, remove the archive. 
## General Good Practices

Beyond the guidelines above, there are a few general good practices I try to stick to.

### In Line Commenting
Scripting logic can get complicated, especially in multi-step automations. What might make perfect sense when I write a script could look foreign months from now when something changes. 
Commenting how a thing works, right where it's working, is a gift to my future self. 

Breadcrumbs are better than nothing. 
### No Secrets
It's 2026 (as of the time of this writing). Any automations should be backed up, using some form of change control, so that each piece can be tracked over time. 

API keys, secrets, passwords, etc do not deserve to be tracked over time. 

Code should be clean, secrets should be abstracted, inserted via environment variable or vault, or passed as a parameter at runtime. I have been guilty of this, and I'm sure I have some scripts that have yet to be cleaned up, but this is a habit we all need to build. 
### Minimal Shortcuts

I try to use to sensible variable names and full verbs in my scripts. File size of scripts is largely not a concern, and having to decode shorthand hurts future review. 

```powershell
gci C:\TEMP
```

is far less legible than

```powershell
Get-ChildItem C:\TEMP
```
### Usable Logging

Not everything needs a log file, but it is super useful to shape output so it can be easy to track when an issue does occur. 

Bad logging would tell you things happened, but be hard to decipher.
```powershell
# This is bad logging
Write-Host "Some stuff happened"
Write-Host "Then it broke"

# The console receives
Some stuff happened
Then it broke
```

Usable logging is a little more descriptive and includes tagging to make filtering easier.

```Powershell
# This is usable logging
Write-Host "[INFO] Software package $($software.Name) will be installed."
Write-Host "[INFO] Downloaded file could not be found at $($package.Path)."
Write-Host "[FAIL] Software package $($software.Name) could not be installed."

# The console receives
[INFO] Software package example will be installed.
[INFO] Downloded file could not be found at C:\TEMP\example.msi
[FAIL] Software package example could not be installed.
```
### Use Functions (When it Makes Sense)

Functions are great. Almost any time you can make a complex task more easily usable is a win. Even more so when the task is highly repeatable. 

Sometimes a function doesn't make sense though. Sometimes a function is just there for the sake of having a function. 

If a function is a wrapper for an existing verb, reconsider the need of a dedicated function to complete or repeat the tasks. Adding the function may be introducing complexity without real benefit.
## Tactical Specific

There are a few tips to keep in mind when using Tactical RMM specifically

### Exit Codes

Tactical can work with just about any exit code you want to use, but there is a specific way they want it set. 

In PowerShell, to exit a script with an error code such as 3, tactical would expect the following

```powershell
$host.SetShouldExit(3)
exit
```

