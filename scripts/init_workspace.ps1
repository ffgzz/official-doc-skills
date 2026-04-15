param(
  [string]$Template = "zs-feasibility-report"
)

$pluginRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$workspaceRoot = Join-Path $pluginRoot "workspace"
$dirs = @(
  (Join-Path $workspaceRoot "plan"),
  (Join-Path $workspaceRoot "outputs\$Template"),
  (Join-Path $workspaceRoot "tables\$Template"),
  (Join-Path $workspaceRoot "figures\$Template"),
  (Join-Path $workspaceRoot "assembled\$Template"),
  (Join-Path $workspaceRoot "review")
)

foreach ($dir in $dirs) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$planTemplate = Join-Path $pluginRoot "plan-template"
$planFiles = @("project-overview.md", "source-materials.md", "facts-ledger.md", "progress.md")
foreach ($file in $planFiles) {
  $target = Join-Path (Join-Path $workspaceRoot "plan") $file
  if (-not (Test-Path $target)) {
    Copy-Item (Join-Path $planTemplate $file) $target
  }
}

Write-Host "Workspace initialized at $workspaceRoot for $Template"
