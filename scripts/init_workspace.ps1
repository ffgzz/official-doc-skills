param(
  [string]$ProjectSlug = "current-project"
)

$pluginRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$workspaceRoot = Join-Path $pluginRoot "workspace"
$dirs = @(
  (Join-Path $workspaceRoot "plan\$ProjectSlug"),
  (Join-Path $workspaceRoot "outputs\$ProjectSlug"),
  (Join-Path $workspaceRoot "tables\$ProjectSlug"),
  (Join-Path $workspaceRoot "figures\$ProjectSlug"),
  (Join-Path $workspaceRoot "review\$ProjectSlug"),
  (Join-Path $workspaceRoot "assembled\$ProjectSlug")
)

foreach ($dir in $dirs) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$planTemplate = Join-Path $pluginRoot "plan-template"
$planFiles = @(
  "project-overview.md",
  "project-brief.md",
  "research-sources.md",
  "facts-ledger.md",
  "progress.md"
)
foreach ($file in $planFiles) {
  $target = Join-Path (Join-Path $workspaceRoot "plan\$ProjectSlug") $file
  if (-not (Test-Path $target)) {
    Copy-Item (Join-Path $planTemplate $file) $target
  }
}

Write-Host "Workspace initialized at $workspaceRoot for $ProjectSlug"
