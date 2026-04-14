param(
  [string]$HookName = "session-start"
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pluginRoot = Split-Path -Parent $scriptDir
$entrySkillFile = Join-Path $pluginRoot "skills\using-official-docs\SKILL.md"

if (Test-Path $entrySkillFile) {
  $entrySkillContent = Get-Content -Raw -Encoding UTF8 $entrySkillFile
  $contextLines = @(
    "<EXTREMELY_IMPORTANT>",
    "The official-doc-writing-skill plugin is loaded.",
    "",
    "For any request about these supported document types, you must follow the using-official-docs entry skill before free-form drafting:",
    "1. ZS feasibility report",
    "2. Full research project template",
    "3. Continue / revise / add tables / add figures / review / assemble for either of the above",
    "",
    "Users may only provide:",
    "- document type",
    "- materials path or files",
    "- current request",
    "",
    "You must handle:",
    "- choose the main template",
    "- initialize or reuse plan/ outputs/ tables/ figures/ review/ assembled/",
    "- read the template files under templates/<template>/",
    "- hand off body drafting to the proper main skill",
    "- proactively call table / figure / review / revise / assemble skills when needed",
    "",
    "Do not require a reference sample just to decide structure or style.",
    "Prefer template files and built-in skill rules.",
    "",
    "Full entry skill content follows:",
    "",
    $entrySkillContent,
    "</EXTREMELY_IMPORTANT>"
  )
  $context = $contextLines -join [Environment]::NewLine
}
else {
  $context = "official-doc-writing-skill loaded, but entry skill file is missing. Prefer official-doc-writing-skill:using-official-docs."
}

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
