# -*- coding: utf-8 -*-
fpath = r'D:\文件\HaiZhou\公文写作三\official-doc-writing-skill-rebuilt\workspace\assembled\ship-ai-design\formal-draft.md'
content = open(fpath, 'r', encoding='utf-8').read()
lines = content.split('\n')

slogans = [
    '本项目拟构建',
    '本课题拟开展',
    '实现从设计意图理解',
    '形成从设计意图理解',
    '为模型持续迭代优化奠定',
    '为各AI模型训练提供高质量样本',
    '工程设计自动化能力得到实质提升',
    '工程设计自动化能力获得有效提升',
    '形成设计意图理解到设计方案自动生成的技术链路',
    '填补国内',
    '国际领先',
    '首创',
]

print('=== 命中的 slogsn 句式 ===')
for i, line in enumerate(lines, 1):
    s = line.strip()
    if s.startswith('```') or s.startswith('>'):
        continue
    for phrase in slogans:
        if phrase in line:
            # 截取含关键词的局部
            idx = line.find(phrase)
            start = max(0, idx-20)
            end = min(len(line), idx + len(phrase) + 20)
            print(f'Line {i}: ...{line[start:end]}...')
            break
