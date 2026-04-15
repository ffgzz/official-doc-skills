param(
  [string]$HookName = "session-start"
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pluginRoot = Split-Path -Parent $scriptDir
$contextLines = @(
  "<EXTREMELY_IMPORTANT>",
  "The official-doc-writing-skill plugin is loaded.",
  "",
  "For the following requests, you must first follow skills/using-official-docs/SKILL.md before any free-form drafting:",
  "- 我要写 ZS-项目可行性报告，材料在 ...",
  "- 我要写 完整科研项目模板，材料在 ...",
  "- 继续推进 / 修改 / 补表 / 补图 / 复核 / 合稿 for either of those document types",
  "",
  "Treat document-type + materials-path requests as a direct trigger for using-official-docs.",
  "Do not wait for the user to mention the skill name.",
  "Do not ask for a reference sample just to decide structure or workflow.",
  "using-official-docs is a router and workspace initializer only. It must not directly draft chapter files, tables, figures, review files, or assembled final drafts.",
  "The required skill order is: using-official-docs -> official-doc-core -> target main/public skill.",
  "Do not treat merely reading official-doc-core as sufficient. You must explicitly apply official-doc-core as a separate step before body/table/figure/review/revise/assemble work.",
  "After using-official-docs determines the next step, immediately switch to the proper main/public skill before generating those artifacts.",
  "",
  "The entry skill is the mandatory first step for:",
  "1. template selection",
  "2. workspace initialization or reuse",
  "3. state detection",
  "4. routing to the proper main/public skill",
  "",
  "If the user says only '我要写 ZS-项目可行性报告，材料在 materials/test-case-zs/' you should still trigger using-official-docs immediately.",
  "If the user says only '我要写 完整科研项目模板，材料在 materials/test-case-full/' you should still trigger using-official-docs immediately.",
  "</EXTREMELY_IMPORTANT>"
)
$context = $contextLines -join [Environment]::NewLine

if ($env:CLAUDE_PLUGIN_ROOT) {
  $payload = @{
    hookSpecificOutput = @{
      hookEventName     = "SessionStart"
      additionalContext = $context
    }
  }
}
else {
  $payload = @{ additional_context = $context }
}

$payload | ConvertTo-Json -Depth 6 -Compress
