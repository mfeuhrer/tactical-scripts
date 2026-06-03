# CheckMK Agent Management

This document will outline how to manage deployments of the checkMK agent in a managed environment. 

## Requirements
### Scripts
[[scripts/installs/Deploy - CheckMK.ps1]](https://git.masonfeuhrer.com/pub/tacticalrmm-scripts/-/blob/main/scripts/installs/Deploy%20-%20CheckMK.ps1) - The primary deployment script. 

Requires Arguments: 
```
-enable_omd {{client.enable_omd}}
```
```
-omd_host {{client.omd_host}}
```
```
-omd_site {{client.omd_site}}
```
```
-omd_agent_version {{client.omd_agent_version}}
```

[[scripts/maintenance/Set -CheckMK TLS.ps1]](https://git.masonfeuhrer.com/pub/tacticalrmm-scripts/-/blob/main/scripts/maintenance/Set%20-%20CheckMK%20TLS.ps1) - Optional script to register the endpoint for encrypted agent communications. 

Requires arguments:
```
-enable_omd {{client.enable_omd}}
```
```
-omd_host {{client.omd_host}}
```
```
-omd_site {{client.omd_site}}
```
```
-omd_user {{client.omd_user}}
```
```
-omd_token {{client.omd_token}}
```

Arguments

| Name               | Definition                                                            |
| ------------------ | --------------------------------------------------------------------- |
| -enable_omd        | $true = deploy                                                        |
| -omd_host          | fqdn of the checkMK server                                            |
| -omd_site          | site to register to in checkMK                                        |
| -omd_user          | username to register endpoints with                                   |
| -omd_token         | password of the user to register endpoints with                       |
| -omd_agent_version | provide specific version if required. Otherwise accept server latest. |

### Custom Fields

If you add and populate the following fields, You'll be able to use tokens to pass the arguments dynamically.

| Field Level | Field Name        | Field Type |
| ----------- | ----------------- | ---------- |
| Client      | enable_omd        | Checkbox   |
| Client      | omd_host          | Text       |
| Client      | omd_site          | Text       |
| Client      | omd_user          | Text       |
| Client      | omd_token         | Text       |
| Client      | omd_agent_version | Number     |

### Policy Items
I have the following items configured on my managed policies to maintain this software.
#### Checks
#### Tasks

## How to Enable

Populate the custom fields with valid checkMK data and toggle enable_omd to true. 

You can then run the scripts manually, or apply the above Checks and Tasks to a policy to let automation take over. 