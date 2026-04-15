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
  "Default to skills/using-official-docs/SKILL.md when the user wants to draft formal Chinese project materials.",
  "The workflow is now prompt-driven: topic + chapter requirements + table/figure requirements + word counts.",
  "",
  "Required order:",
  "1. using-official-docs parses the brief and initializes the project-slug workspace",
  "2. official-doc-core runs as a separate step",
  "3. Only the five shared chapter types use dedicated section skills:",
  "- 项目背景",
  "- 研究内容",
  "- 创新点",
  "- 主要技术成果",
  "- 主要技术指标",
  "4. Other chapters are drafted directly from the brief",
  "",
  "For those five shared chapter types, web search and source logging are mandatory before drafting.",
  "Keep table / figure / review / revise / assemble as the downstream common flow.",
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
