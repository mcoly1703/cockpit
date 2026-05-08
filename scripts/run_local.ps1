# Lance Flutter avec les credentials Supabase local
# Usage : .\scripts\run_local.ps1
# Usage (device) : .\scripts\run_local.ps1 -device chrome

param(
  [string]$device = ""
)

$url     = "http://127.0.0.1:54321"
$anonKey = "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH"

$args = @(
  "run",
  "--dart-define=SUPABASE_URL=$url",
  "--dart-define=SUPABASE_ANON_KEY=$anonKey",
  "--dart-define=APP_ENV=development"
)

if ($device -ne "") {
  $args += "-d"
  $args += $device
}

Write-Host "▶  Flutter local → $url" -ForegroundColor Green
Set-Location "$PSScriptRoot\..\frontend"
flutter @args