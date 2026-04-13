---
name: official-doc-review
description: Use when the current official-document workflow reaches a review point or the user asks to check the draft - reviews ZS-项目可行性报告 or 完整科研项目模板 for headings, numbering, terminology, tables, figures, schedule, budget, and unresolved placeholders
allowed-tools: Read Write Edit Bash
---

# 公文复核 Skill

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- 用户明确要求检查、复核、体检、定稿前核验
- 当前一轮正文、表格、图示已经生成，需要阶段性检查
- 你准备告诉用户“这一轮已完成”

## 核心目标

对已经生成的骨架、正文、表格、图示做结构化体检，输出可执行的问题清单，而不是只给一句泛泛评价。

## 检查维度

### 1. 标题完整性
- 一级标题是否齐全
- 二级标题是否遗漏
- 是否擅自改写模板固定标题
- 编号顺序是否连续

### 2. 图表一致性
- 图号、表号是否连续
- caption 是否与目录一致
- 正文是否正确引用图表
- 图表内容是否与正文口径一致

### 3. 事实一致性
- 项目名称是否统一
- 单位全称/简称是否统一
- 负责人、成员、职责是否冲突
- 起止时间和阶段计划是否冲突
- 成果数量、预算口径是否冲突

### 4. 风险项
- 是否存在大量 `【待补】`
- 是否存在明显空话套话
- 是否存在“图表已有但正文未引用”
- 是否存在“正文提到表图但文件未生成”

## 输出格式

输出到：
- `review/<template>-review.md`

建议结构：
1. 已通过项
2. 问题项
3. 建议修复顺序
4. 仍需补充材料清单

## 表达要求

问题必须写到可执行，不要只写抽象判断。

例如：
- 不写：`预算有问题`
- 要写：`第9章预算说明中的总预算为120万元，而表6合计为110万元，建议先统一总预算口径，再修订分项。`

## 交付后动作

- 更新 `plan/progress.md`
- 若发现大量共性问题，回写 `plan/facts-ledger.md` 或 `plan/source-materials.md`
