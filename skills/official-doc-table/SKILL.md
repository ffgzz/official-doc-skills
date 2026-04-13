---
name: official-doc-table
description: Use when the current official-document workflow explicitly or implicitly needs tables for ZS-项目可行性报告 or 完整科研项目模板 - generates caption-locked tables, notes, and source-gap tracking without requiring the user to ask separately
allowed-tools: Read Write Edit Bash
---

# 公文表格 Skill

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- 用户明确说要补表
- 当前正文已出现表格引用位
- 当前章节天然依赖表格来承载结构化信息
- 入口 Skill 或主 Skill 判断当前下一步最合理的是补表

## 核心目标

把“表标题 + 字段定义 + 数据来源 + 待补项”生成标准表，而不是继续塞回正文段落。

## 使用前必做

1. 确认当前模板是 `zs-feasibility-report` 还是 `full-research-template`
2. 读取对应 `table-catalog.md`
3. 锁定表 caption
4. 核对正文中该表的引用位置
5. 核对 `plan/facts-ledger.md` 中相关口径

## 输出格式

每张表至少输出：
- `tables/<template>/<table-file>.md`
- `tables/<template>/<table-file>-notes.md`

其中 `notes` 必须写清：
- 当前表服务哪个章节
- 每列字段来自哪里
- 哪些值是 `【待补】`
- 哪些口径已与正文核对

## 强制规则

- caption 不改
- 表头尽量贴近模板字段
- 不擅自新增“看起来合理”的指标列
- 数值、单位、时间必须与正文一致
- 不知道的字段直接写 `【待补】`
- 更新 `plan/progress.md`

## ZS-项目可行性报告优先表格

- 表1 项目任务表
- 表2 项目主要成员
- 表3 项目技术成果
- 表4 项目预期成效
- 表5 项目攻关计划进度安排
- 表6 经费预算表

## 完整科研项目模板优先表格

优先处理以下三类：
- 组织与团队类
- 成果与任务分配类
- 经费与投资测算类

## 交付前检查

- 表号与正文引用一致
- 表头与章节语义一致
- 与正文口径冲突的地方已在 notes 中标出
