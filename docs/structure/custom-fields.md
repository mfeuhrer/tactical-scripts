# Custom Fields Matrix

Below are the different fields I'm using and how they're configured. If you add these to your own instance, my scripts should just drop into place.

In general, I find that following a guideline of global toggles with localized exclusions scales the best, and my CF layout reflects that approach.


## Client Level Fields


| Name              | Field Type | Default Value   | Definition                                                                                                                                                      |
| ----------------- | ---------- | --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| enable_omd        | Checkbox   | N/A             | toggling this will allow scripts to install the checkmk software and enable alerting if the software is not installed.                                          |
| omd_host          | Text       | omd.omicr0n.com | fqdn of the checkMK server. No https:// or trailing slash                                                                                                       |
| omd_site          | Text       | N/A             | checkMK servers are separated into sites. Use this to define the specific site.                                                                                 |
| omd_user          | Text       | N/A             | checkMK server requires a user to authenticate registrations.                                                                                                   |
| omd_token         | Text       | N/A             | password for the registration user.                                                                                                                             |
| omd_agent_version | Number     | N/A             | checkMK servers can host sites at different levels. specify a site version here, otherwise the script will default to the latest version of the omicr0n server. |



## Site Level Fields

| Name              | Field Type | Default Value | Definition                                                                                                                                  |
| ----------------- | ---------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Time Zone         | Text       | N/A           | Accepts Windows Time Zone to allow managing TZ on servers. e.x.: Central Standard Time                                                      |
| snipe_locID       | Number     | N/A           | hidden custom field used by platform automation. represents location mapping when snipeIT is in use.                                        |
| Action1 Installer | Text       | N/A           | action1 is intended to by managed by site. Provide the full URL to the site specific installer here. *may become an override in the future* |

## Agent Level Fields

| Name                          | Field Type | Default Value | Definition                                                                                 |
| ----------------------------- | ---------- | ------------- | ------------------------------------------------------------------------------------------ |
| WUA Version                   | Text       | N/A           | used to track the level of windows update components on device                             |
| system_python                 | Text       | N/A           | used to determine installed python version recognized by the machine, rather than the user |
| librenms                      | Text       | N/A           | populated by n8n with a link to the device if it exists in librenms.                       |
| Installed Chocolatey Packages | Text       | N/A           | intended to hold a list of any packages currently managed via chocolatey.                  |
| fqdn                          | Text       | N/A           | hidden custom field used in platform automation. helps match device in other tools.        |