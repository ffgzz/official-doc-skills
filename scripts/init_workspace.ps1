\
param(
  [string]$Template = "zs-feasibility-report"
)

$dirs = @(
  "plan",
  "outputs\$Template",
  "tables\$Template",
  "figures\$Template",
  "review"
)

foreach ($dir in $dirs) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$planTemplate = Join-Path $PSScriptRoot "..\plan-template"
$planFiles = @("project-overview.md", "source-materials.md", "facts-ledger.md", "progress.md")
foreach ($file in $planFiles) {
  $target = Join-Path (Join-Path $PSScriptRoot "..\plan") $file
  if (-not (Test-Path $target)) {
    Copy-Item (Join-Path $planTemplate $file) $target
  }
}

Write-Host "Workspace initialized for $Template"
