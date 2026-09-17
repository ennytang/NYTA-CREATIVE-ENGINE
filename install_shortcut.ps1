# ─────────────────────────────────────────────────────────────────────────────
#  NYTA CREATIVE ENGINE — desktop shortcut installer
#  Creates a shortcut that launches Chrome in application mode: no tabs, no
#  address bar, its own profile, and downloads pointed at ./OUTPUT.
#  Resolves its own location, so it works wherever the folder lives.
# ─────────────────────────────────────────────────────────────────────────────
$ErrorActionPreference = 'Stop'

$dir    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$html   = Join-Path $dir 'nyta_creative_engine.html'
$prof   = Join-Path $dir '.chrome-profile'
$ico    = Join-Path $dir 'nyta.ico'
$outdir = Join-Path $dir 'OUTPUT'

if (-not (Test-Path $html)) { throw "nyta_creative_engine.html not found in $dir" }
if (-not (Test-Path $outdir)) { New-Item -ItemType Directory -Path $outdir | Out-Null }

$chrome = @(
  'C:\Program Files\Google\Chrome\Application\chrome.exe',
  'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
  (Join-Path $env:LOCALAPPDATA 'Google\Chrome\Application\chrome.exe')
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $chrome) { throw 'Google Chrome not found.' }

# Point this profile's downloads at ./OUTPUT so exports land next to the tool.
$prefDir = Join-Path $prof 'Default'
if (-not (Test-Path $prefDir)) { New-Item -ItemType Directory -Path $prefDir -Force | Out-Null }
$prefFile = Join-Path $prefDir 'Preferences'
if (-not (Test-Path $prefFile)) {
  $prefs = @{
    download = @{ default_directory = $outdir; prompt_for_download = $false; directory_upgrade = $true }
    profile  = @{ name = 'NYTA' }
    bookmark_bar = @{ show_on_all_tabs = $false }
  } | ConvertTo-Json -Depth 5
  [System.IO.File]::WriteAllText($prefFile, $prefs)
  [System.IO.File]::WriteAllText((Join-Path $prof 'First Run'), '')
}

$url     = 'file:///' + ($html -replace '\\','/')
$argline = '--app="' + $url + '" --user-data-dir="' + $prof + '" --window-size=1680,1000 --window-position=60,40'

$ws      = New-Object -ComObject WScript.Shell
$desktop = $ws.SpecialFolders('Desktop')

foreach ($p in @((Join-Path $desktop 'NYTA Creative Engine.lnk'), (Join-Path $dir 'NYTA Creative Engine.lnk'))) {
  $l = $ws.CreateShortcut($p)
  $l.TargetPath       = $chrome
  $l.Arguments        = $argline
  $l.WorkingDirectory = $dir
  if (Test-Path $ico) { $l.IconLocation = "$ico,0" }
  $l.Description      = 'NYTA Creative Engine'
  $l.WindowStyle      = 1
  $l.Save()
  Write-Output "created: $p"
}
Write-Output "chrome:  $chrome"
Write-Output "output:  $outdir"
