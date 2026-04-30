$content = Get-Content -Path "D:\文件\HaiZhou\公文写作三\official-doc-writing-skill-rebuilt\generated-drafts\zs-test\完整文稿.md" -Raw -Encoding UTF8
# Remove mermaid code blocks for counting
$cleanContent = $content -replace '(?s)```mermaid.*?```' -replace '(?s)```.*?```', ''
# Count Chinese characters
$chineseChars = [regex]::Matches($cleanContent, '[\u4e00-\u9fff]') | Measure-Object | Select-Object -ExpandProperty Count
$totalChars = $cleanContent.Length
Write-Host "Total Chinese characters (approx): $chineseChars"
Write-Host "Total chars (including punctuation/Latin): $totalChars"

# Count by chapter
$chapters = @(
    "一、项目背景及必要性",
    "二、项目单位基本情况",
    "三、项目团队工作基础",
    "四、项目建设方案",
    "五、项目任务设置",
    "六、联合体成员单位任务分工情况",
    "七、项目组织及实施管理",
    "八、资金筹措及投资估算",
    "九、财务经济效益测算",
    "十、项目综合风险因素分析"
)

foreach ($ch in $chapters) {
    $pattern = "(?s)##?\s*$ch.*?(?=##?\s*(?:[^#\n]+)|$)"
    if ($cleanContent -match $pattern) {
        $chapterContent = $Matches[0]
        $cc = [regex]::Matches($chapterContent, '[\u4e00-\u9fff]') | Measure-Object | Select-Object -ExpandProperty Count
        Write-Host "Chapter '$ch': $cc Chinese chars"
    } else {
        Write-Host "Chapter '$ch': NOT FOUND"
    }
}
