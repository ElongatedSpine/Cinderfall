# Publish a compiled Cinderfall Quest APK to GitHub Releases.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^v\d+\.\d+(\.\d+)?$')]
    [string]$Version,
    [Parameter(Mandatory = $true)]
    [string]$Notes,
    [string]$ApkPath = "$HOME\OneDrive\Desktop\Cinderfall-builds\Quest3\Cinderfall.apk"
)
$ErrorActionPreference = 'Stop'
$Repo = 'ElongatedSpine/Cinderfall'
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw 'Install GitHub CLI and run gh auth login first.'
}
if (-not (Test-Path -LiteralPath $ApkPath -PathType Leaf)) {
    throw "APK not found: $ApkPath"
}
$Apk = Get-Item -LiteralPath $ApkPath
if ($Apk.Name -cne 'Cinderfall.apk') {
    throw 'The APK must be named Cinderfall.apk so the latest download URL stays consistent.'
}
gh auth status
if ($LASTEXITCODE -ne 0) { throw 'Run gh auth login first.' }
# The caller must verify the APK package, increasing Android versionCode,
# signing certificate, and Quest functionality before publishing.
gh release create $Version $Apk.FullName --repo $Repo --title "Cinderfall $Version" --notes $Notes --latest
if ($LASTEXITCODE -ne 0) { throw 'Release failed. Check the GitHub Releases page before retrying.' }
Write-Host 'Published: https://github.com/ElongatedSpine/Cinderfall/releases/latest/download/Cinderfall.apk'
