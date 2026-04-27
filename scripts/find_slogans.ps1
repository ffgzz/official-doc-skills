$content = Get-Content 'D:\文件\HaiZhou\公文写作三\official-doc-writing-skill-rebuilt\workspace\assembled\ship-ai-design\formal-draft.md' -Raw
$lines = $content -split "`n"
$slogans = @('实现从', '形成从', '本项目拟', '本课题拟', '实现设计意图理解', '为模型持续迭代优化奠定', '为各AI模型训练提供高质量样本', '工程设计自动化能力得到实质提升', '工程设计自动化能力获得有效提升', '填补国内', '国际领先', '首创', '形成设计意图理解到设计方案自动生成的技术链路')
$found = @()
foreach ($i in 0..($lines.Length-1)) {
    $line = $lines[$i]
    if ($line -match '```') { continue }
    foreach ($s in $slogans) {
        if ($line -match $s) {
            $ctx = $line.Substring(0, [Math]::Min(100, $line.Length))
            $found += "Line $($i+1): $ctx"
        }
    }
}
$found | ForEach-Object { Write-Output $_ }
