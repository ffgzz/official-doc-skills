---
name: official-doc-table
description: Use when the user brief or a drafted chapter requires project tables. This skill reads the parsed chapter plan, generates only the requested tables for the current project slug, keeps table contents consistent with the chapter text and search evidence, and writes table notes for later assembly.
allowed-tools: Read Write Edit Bash
---

# 公文表格 Skill

> 当前表格流程只依据：
> - `project-brief.md`
> - `00-section-plan.md`
> - 当前章节正文
> - `facts-ledger.md` 与 `research-sources.md`

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- 用户明确说要补表
- 当前正文已出现表格引用位
- 当前章节天然依赖表格来承载结构化信息
- 入口 Skill 或主 Skill 判断当前下一步最合理的是补表

## 核心目标

把“表标题 + 字段定义 + 数据来源 + 待补项”生成标准表，而不是继续塞回正文段落。

## 使用前必做

1. 读取 `workspace/plan/<project-slug>/project-brief.md`
2. 读取 `workspace/outputs/<project-slug>/00-section-plan.md`
3. 读取当前章节正文
4. 核对 `workspace/plan/<project-slug>/facts-ledger.md`
5. 如表格涉及行业对比或公开指标，再核对 `research-sources.md`

## 选择逻辑

### 先决定“补哪张表”

默认按以下顺序判断：
1. 用户在 brief 中明确要求的表
2. `00-section-plan.md` 中已登记的表
3. 当前正文已经出现引用位的表
4. 当前章节最需要结构化承载的信息

### 再决定“补到什么粒度”

默认按以下信息来定：
- 所属章节
- 当前表的用途
- 正文已出现或用户明确要求的字段
- 可支持这些字段的事实与来源
- 待补项与装配位置

不要脱离正文，凭经验写一个“差不多”的表。

## 输出格式

每张表至少输出：
- `workspace/tables/<project-slug>/<table-file>.md`
- `workspace/tables/<project-slug>/<table-file>-notes.md`

其中 `notes` 必须写清：
- 当前表服务哪个章节
- 当前表的用途
- 每列字段来自哪里
- 哪些值是 `【待补】`
- 哪些口径已与正文核对
- 装配时应插入到正文哪个位置

## 强制规则

- caption 不改
- 表头尽量贴近用户要求与正文字段
- 不擅自新增“看起来合理”的指标列
- 数值、单位、时间必须与正文一致
- 不知道的字段直接写 `【待补】`
- 更新 `workspace/plan/progress.md`
- 如果材料、facts-ledger、既有正文或既有表文件中已经有明确姓名、单位、牵头单位、时间、成果、预算口径，不得在新表中回退成 `【待补】`
- 若原始模板或材料中的某个关键单元格本来就是空白，正式导向的表格可保留空单元格；不要为了提醒自己而把正式表整体重写成 `【待补】` 版本

## notes 写法建议

每张 `-notes.md` 建议至少包含：
1. 表 caption 与所属章节
2. 当前表的用途
3. 当前采用的表头
4. 各列字段来源
5. 待补项
6. 与正文核对结果
7. 装配提示

## 装配前源数据规则

- `workspace/tables/<project-slug>/<table-file>.md` 是该表在后续装配阶段的唯一文字数据源
- `official-doc-assemble` 应直接纳入这份表文件，而不是凭记忆或根据正文重新生成一版“看起来差不多”的表
- 如果 later stage 发现表格需要修正，应先回写这份表文件，再进入 assemble；不要只在 formal-draft 里局部偷改

## 与章节配比的关系

- 当章节本身较短时，表格可以承担更多信息量
- 当章节本身较重时，表格主要起结构化补充作用
- 不要为了凑页数扩表

## 交付前检查

- 表号与正文引用一致
- 表头与章节语义一致
- 与正文口径冲突的地方已在 notes 中标出
- notes 已写清来源、待补项和装配位置
