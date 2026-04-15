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

把分散在 `workspace/outputs/`、`workspace/tables/`、`workspace/figures/` 的中间产物装配为一份正式总稿。
没有这一步，项目只能得到“工作区产物包”，不能得到完整交付稿。

## 使用前必读

开始装配前，至少读取以下文件：
- `templates/<template>/outline.md`
- `templates/<template>/table-catalog.md`
- `templates/<template>/figure-catalog.md`
- `workspace/review/<template>-review.md`
- 最近一轮 `revise` 结果说明
- 当前要纳入装配的 `workspace/outputs/`、`workspace/tables/`、`workspace/figures/` 文件

## 输出目录

输出到：
- `workspace/assembled/<template>/<template>-formal-draft.md`
- `workspace/assembled/<template>/<template>-assembly-notes.md`

`assembly-notes` 至少要写清：
- 本次装配纳入了哪些正文文件
- 本次装配纳入了哪些表格 / 图示
- 仍保留了哪些 `【待补】`
- 是否已完成 review / revise
- 是否仍存在未修复 Must Fix
- 哪些高优先表图尚未纳入装配
- 本次章节比例和 `【待补】` 统计是基于哪一版正式稿实时计算的
- 若用户给出总字数要求，本次正式稿的目标总字数、当前统计总字数与偏差是多少
- 本次统计是否排除了表格单元格、Mermaid、引用提示行
- 本次 `【待补】` 采用的是字段数还是标记数

## 装配规则

- 装配顺序必须与模板章节顺序一致
- 以正文章节文件为主线进行拼装
- 在正文引用位附近插入对应表格 / 图示内容，不要只保留孤立文件路径
- `workspace/outputs/`、`workspace/tables/`、`workspace/figures/` 中的最新文件是装配唯一数据源；装配时不得凭记忆重写正文、表格或图示
- 已生成的表格在装配时应直接纳入其最新 `.md` 文件内容，不得在 `formal-draft` 中再手写一版简化表或回退成更多 `【待补】`
- 图表 caption、编号、术语必须与正文一致
- 装配完成后，不得直接结束流程；必须再对当前 `formal-draft` 执行一轮 final review
- 如果 review 中仍有未修复的 Must Fix，不能直接宣称“最终定稿”
- 如果高优先表图尚未齐备，不得进入装配
- 装配时要优先纳入 `table-catalog.md` / `figure-catalog.md` 中标为“必出”或“高优先”的项目
- 若正式稿中的任一表图内容与对应散件文件不一致，必须视为装配失败并回到 revise / assemble 修复

## 装配前判定

装配前必须先给出结论：
- `可装配正式稿`
- `暂不可装配`

判定口径如下：
- 若全书必需章节已齐、Must Fix 已清、高优先表图已齐、review / revise 已完成，可装配正式稿
- 若仍缺必需章节正文、高优先表图、存在未修复 Must Fix，或 review / revise 尚未完成，则暂不可装配
- 若当前 `assembly-notes` 的字数、比例、`【待补】` 数与当前 `formal-draft` 不一致，也不得判为正式稿

## 装配后强制动作

装配完成后，必须立即执行以下动作：
1. 重新读取当前 `workspace/assembled/<template>/<template>-formal-draft.md`
2. 基于当前 `formal-draft` 重新计算章节比例与 `【待补】` 数
3. 立即调用 `official-doc-review` 做一轮 final review
4. 生成 `workspace/review/<template>-final-review.md`
5. 仅当 final review 未发现新的 Must Fix 时，才允许把装配结果标记为“可装配正式稿”

不要把装配前的 review 直接沿用为装配后的最终判断。

## ZS-项目可行性报告装配要求

- 按第1章到第10章顺序装配
- `图1`、`表1` 至 `表6` 应插入对应章节附近
- 第7章到第9章保持“短正文 + 表格主体”的版式，不要在装配时又扩写成长段
- 若第1章到第10章缺任一章，不得进入装配
- 若 `图1` 或 `表1` 至 `表6` 缺任一项，不得进入装配
- 只有在 10 章正文完成、表图补齐、review / revise 完成后，才允许装配正式总稿
- 若 `table-01.md` 至 `table-06.md` 中已有明确牵头单位、成员名单、时间节点或预算口径，装配稿不得退回为更空的占位版本

## 完整科研项目模板装配要求

- 只有在 7 章正文全部完成后，才允许进入装配
- 不允许因为已经完成若干单章，就先输出任何 assembled 阶段稿
- 若第2章、第3章、第5章的高优先图表未齐，不得进入装配
- 第2章仍偏薄时，不应用装配动作掩盖正文缺口，应先回到 revise 补正文和高优先图表
- 若第4章已有更完整的组织管理条目，第3章已有更完整的任务边界，装配稿不得退回为更薄的概述版
- 若成果类、任务类、资金类表格在 `workspace/tables/full-research-template/` 中已有明确值，装配稿不得回退为大量 `【待补】` 的占位版本

## 交付后动作

- 更新 `workspace/plan/progress.md`
- 如果装配稿仍存在明显缺口，回写 `workspace/review/` 或 `workspace/plan/`，不要假装已经完全定稿
- 更新 `workspace/assembled/<template>/<template>-assembly-notes.md` 时，所有章节比例、`【待补】` 数和装配判定都必须基于当前 `formal-draft` 重新计算，不得沿用旧 review 中已经过期的统计值
- `assembly-notes` 的章节比例和 `【待补】` 统计方法必须与 `workspace/review/<template>-final-review.md` 完全一致
- 在 `workspace/plan/progress.md` 中明确记录：是否已完成装配后 final review，以及 final review 的结论
- 若用户给出了总字数要求，还必须在 `assembly-notes` 和 `progress.md` 中记录“目标总字数 / 当前总字数 / 是否达标”
- 在 `workspace/assembled/<template>/<template>-assembly-notes.md` 中写明 final review 文件路径：`workspace/review/<template>-final-review.md`
