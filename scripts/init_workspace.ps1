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
  "stage-gates.md",
  "research-plan.md",
  "research-sources.md",
  "research-notes.md",
  "facts-ledger.md",
  "progress.md",
  "source-materials.md"
)
foreach ($file in $planFiles) {
  $target = Join-Path (Join-Path $workspaceRoot "plan\$ProjectSlug") $file
  if (-not (Test-Path $target)) {
    Copy-Item (Join-Path $planTemplate $file) $target
  }
}

$sectionPlan = Join-Path (Join-Path $workspaceRoot "outputs\$ProjectSlug") "00-section-plan.md"
if (-not (Test-Path $sectionPlan)) {
  @"
# 章节计划

## 全文编号方案

- 目标文体：
- 编号方案：
- 特殊说明：

## 章节拆解

| 章节序号 | 章节标题 | 命中 skill | 编号层级要求 | 当前状态 | 备注 |
|---|---|---|---|---|---|
"@ | Set-Content -Path $sectionPlan -Encoding UTF8
}

Write-Host "Workspace initialized at $workspaceRoot for $ProjectSlug"
