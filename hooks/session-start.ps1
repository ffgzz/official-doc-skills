param(
  [string]$HookName = "session-start"
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pluginRoot = Split-Path -Parent $scriptDir
$entrySkillFile = Join-Path $pluginRoot "skills\using-official-docs\SKILL.md"

if (Test-Path $entrySkillFile) {
  $entrySkillContent = Get-Content -Raw -Encoding UTF8 $entrySkillFile
  $context = @"
<EXTREMELY_IMPORTANT>
你已加载“公文项目写作助手”。

当用户提出以下任一任务时，你必须优先按入口技能 using-official-docs 的规则处理，而不是直接自由发挥：
1. 写 ZS-项目可行性报告
2. 写 完整科研项目模板
3. 继续修改、补写、补表、补图、复核上述两类文档

用户通常只会提供：
- 文档类型
- 材料目录或材料文件
- 当前诉求（可省略）

你必须自行完成：
- 判定主模板
- 初始化或复用 plan/ outputs/ tables/ figures/ review/
- 读取对应 templates/<template>/ 下的模板文件
- 调用主 Skill 推进正文
- 在需要时主动调用表格、图示、复核 Skill

不要再要求用户提供“参考样稿”来决定结构或风格。
这两类公文的结构、风格、输出方式，应优先依据模板文件和对应 Skill 内建规则处理。

以下是入口技能完整内容：

$entrySkillContent
</EXTREMELY_IMPORTANT>
"@
}
else {
  $context = "公文项目写作助手已加载，但未找到入口技能文件。请优先使用 official-doc-writing-skill:using-official-docs。"
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