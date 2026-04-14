param(
  [string]$Template = "zs-feasibility-report"
)

$pluginRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$dirs = @(
  (Join-Path $pluginRoot "plan"),
  (Join-Path $pluginRoot "outputs\$Template"),
  (Join-Path $pluginRoot "tables\$Template"),
  (Join-Path $pluginRoot "figures\$Template"),
  (Join-Path $pluginRoot "assembled\$Template"),
  (Join-Path $pluginRoot "review")
)

foreach ($dir in $dirs) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$planTemplate = Join-Path $pluginRoot "plan-template"
$planFiles = @("project-overview.md", "source-materials.md", "facts-ledger.md", "progress.md")
foreach ($file in $planFiles) {
  $target = Join-Path (Join-Path $pluginRoot "plan") $file
  if (-not (Test-Path $target)) {
    Copy-Item (Join-Path $planTemplate $file) $target
  }
}

Write-Host "Workspace initialized for $Template"
