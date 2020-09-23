
"Running tests"
$ErrorActionPreference = "Stop"


if ($env:APPVEYOR_BUILD_VERSION) {
  # run in CI
  $version = $env:APPVEYOR_BUILD_VERSION -replace('\.[^.\\/]+$')
} else {
  # run manually
  [xml]$spec = Get-Content pswindowsupdate.nuspec
  $version = $spec.package.metadata.version
}

"TEST: Version $version in pswindowsupdate.nuspec file should match"
[xml]$spec = Get-Content pswindowsupdate.nuspec
if ($spec.package.metadata.version.CompareTo($version)) {
  Write-Error "FAIL: Wrong version in nuspec file!"
}

"TEST: Package should contain install/uninstall scripts"
Add-Type -assembly "system.io.compression.filesystem"
$zip = [IO.Compression.ZipFile]::OpenRead("$pwd\pswindowsupdate.$version.nupkg")
# Write-Host $zip.Entries.FullName
Write-Host $zip.Entries.Count
if ($zip.Entries.Count -ne 15) {
  Write-Error "FAIL: Wrong count in nupkg!"
}
$zip.Dispose()

"TEST: Installation of package should work"
. choco install -y pswindowsupdate -source . -version $version

"TEST: Uninstallation of package should work"
. choco uninstall -y pswindowsupdate -source .

"TEST: Finished"