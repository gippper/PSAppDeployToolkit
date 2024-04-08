<#
.SYNOPSIS

PSAppDeployToolkit - This script contains the PSADT Custom runtime and functions using by a Deploy-Application.ps1 script.

.DESCRIPTION

The script can be called directly to dot-source the toolkit functions for testing, but it is usually called by the Deploy-Application.ps1 script.

The script can usually be updated to the latest version without impacting your per-application Deploy-Application scripts. Please check release notes before upgrading.

PSAppDeployToolkit is licensed under the GNU LGPLv3 License - (C) 2023 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham and Muhammad Mashwani).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details. You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

.INPUTS

None

You cannot pipe objects to this script.

.OUTPUTS

None

This script does not generate any output.

.NOTES

The other parameters specified for this script that are not documented in this help section are for use only by functions in this script that call themselves by running this script again asynchronously.

.LINK

https://psappdeploytoolkit.com
#>

## Set up sample variables if Dot Sourcing the script, app details have not been specified
If (-not $appWinGetID) {
    [String]$appWinGetID = $appDeployMainScriptFriendlyName
    If (-not $appWinGetName) {
        [String]$appWinGetName = 'PS'
    }
Else {
    If (-not $appWinGetID) {
        [String]$appWinGetID = ''
    }
    If (-not $appWinGetName) {
        [String]$appWinGetName = ''
    }

}

[String]$appWinGetSwitches = '--silent --accept-source-agreements --accept-package-agreements'

## Sanitize the application details, as they can cause issues in the script
[String]$appWinGetID = (Remove-InvalidFileNameChars -Name ($appWinGetID.Trim()))
[String]$appWinGetName = (Remove-InvalidFileNameChars -Name ($appWinGetName.Trim()))

# Resolve winget.exe
		$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
		if ($winget_exe.count -gt 1){
				$winget_exe = $winget_exe[-1].Path
		}
		if (!$winget_exe){Write-Error "Winget not installed"}