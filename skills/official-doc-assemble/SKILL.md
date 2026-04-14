---
name: official-doc-assemble
description: Use when ZS-项目可行性报告 or 完整科研项目模板 needs a formal assembled draft - merges outputs, tables, and figures into a single deliverable draft after review and revise
allowed-tools: Read Write Edit Bash
---

# 公文装配 Skill

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- 用户要求“合稿”“总稿”“正式稿”“交付稿”
- 正文、表格、图示已经齐备，且 review / revise 已完成
- 你准备把中间产物装配成一份连续、完整、可交付的正式总稿

## 核心目标

把分散在 `outputs/`、`tables/`、`figures/` 的中间产物装配为一份正式总稿。
没有这一步，项目只能得到“工作区产物包”，不能得到完整交付稿。

## 使用前必读

开始装配前，至少读取以下文件：
- `templates/<template>/outline.md`
- `templates/<template>/table-catalog.md`
- `templates/<template>/figure-catalog.md`
- `review/<template>-review.md`
- 最近一轮 `revise` 结果说明
- 当前要纳入装配的 `outputs/`、`tables/`、`figures/` 文件

## 输出目录

输出到：
- `assembled/<template>/<template>-formal-draft.md`
- `assembled/<template>/<template>-assembly-notes.md`

`assembly-notes` 至少要写清：
- 本次装配纳入了哪些正文文件
- 本次装配纳入了哪些表格 / 图示
- 仍保留了哪些 `【待补】`
- 是否已完成 review / revise
- 是否仍存在未修复 Must Fix
- 哪些高优先表图尚未纳入装配

## 装配规则

- 装配顺序必须与模板章节顺序一致
- 以正文章节文件为主线进行拼装
- 在正文引用位附近插入对应表格 / 图示内容，不要只保留孤立文件路径
- 图表 caption、编号、术语必须与正文一致
- 如果 review 中仍有未修复的 Must Fix，不能直接宣称“最终定稿”
- 如果高优先表图尚未齐备，只能输出“阶段装配稿”或“待补稿”，不能写成“正式定稿”
- 装配时要优先纳入 `table-catalog.md` / `figure-catalog.md` 中标为“必出”或“高优先”的项目

## 装配前判定

装配前必须先给出结论：
- `可装配正式稿`
- `仅可装配阶段稿`
- `暂不可装配`

判定口径如下：
- 若 Must Fix 已清、重章节已成形、高优先表图已齐，可装配正式稿
- 若正文主线可读，但仍有少量 `【待补】` 或中低优先表图未齐，只可装配阶段稿
- 若仍缺重章节正文、高优先表图或存在未修复 Must Fix，则暂不可装配

## ZS-项目可行性报告装配要求

- 按第1章到第10章顺序装配
- `图1`、`表1` 至 `表6` 应插入对应章节附近
- 第7章到第9章保持“短正文 + 表格主体”的版式，不要在装配时又扩写成长段
- 若 `图1` 或 `表1` 至 `表6` 缺任一项，不得写成“正式定稿”；只能按实际情况标注为阶段稿或暂缓装配

## 完整科研项目模板装配要求

- 优先装配已经完成的章节批次
- 未完成章节可以保留明确占位，但必须在 notes 中说明
- 若第3章、第4章、第8章的高优先图表未齐，不得写成“正式定稿”
- 第4章仍偏薄时，不应用装配动作掩盖正文缺口，应先回到 revise 补正文和高优先图表

## 交付后动作

- 更新 `plan/progress.md`
- 如果装配稿仍存在明显缺口，回写 `review/` 或 `plan/`，不要假装已经完全定稿
