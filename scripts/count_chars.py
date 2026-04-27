# -*- coding: utf-8 -*-
import re
fpath = r'D:\文件\HaiZhou\公文写作三\official-doc-writing-skill-rebuilt\workspace\assembled\ship-ai-design\formal-draft.md'
content = open(fpath, 'r', encoding='utf-8').read()
lines = content.split('\n')
chinese_count = 0
code_blocks = False
for l in lines:
    stripped = l.strip()
    if stripped.startswith('```'):
        code_blocks = not code_blocks
        continue
    if code_blocks or stripped.startswith('|') or stripped.startswith('#') or stripped.startswith('>'):
        continue
    chinese_count += len(re.findall(r'[\u4e00-\u9fff]', l))
print('Chinese chars (excl code/table/heading):', chinese_count)
print('Total file length:', len(content))

# Also count slogans
slogans = ['实现从', '形成从', '本项目拟', '本课题拟', '实现设计意图理解到设计方案自动生成', '实现从人操作软件到软件理解人', '填补国内', '国际领先', '首创', '为模型持续迭代优化奠定', '形成设计意图理解到设计方案自动生成的技术链路']
for i, line in enumerate(lines, 1):
    for s in slogans:
        if s in line:
            print(f'Line {i}: {s}')
            break
