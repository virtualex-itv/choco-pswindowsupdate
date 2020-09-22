﻿$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$moduleName = $env:ChocolateyPackageName  # this may be different from the package name and different case
$moduleVersion = $env:ChocolateyPackageVersion  # this may change so keep this here

if ($PSVersionTable.PSVersion.Major -lt 3) {
    throw "$moduleName module requires a minimum of PowerShell v3."
}
# module may already be installed outside of Chocolatey
#Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
if (Get-Module -ListAvailable -Name $moduleName -ErrorAction SilentlyContinue){
		Get-InstalledModule -Name $moduleName | Uninstall-Module -AllVersions -Force -ErrorAction "SilentlyContinue" -Verbose
	}

# install module
Get-PackageProvider -Name "NuGet" -Force
Install-Module -Name $moduleName -Scope AllUsers -RequiredVersion $moduleVersion -Force
Import-Module -Name $moduleName