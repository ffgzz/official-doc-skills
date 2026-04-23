---
name: official-doc-assemble
description: 用于在当前项目满足条件时装配正式总稿。它按照章节顺序整合正文、表格和图示，生成 formal-draft 与 assembly-notes，并在装配后触发 final review。
allowed-tools: Read Write Edit Bash
---

# 公文装配 Skill

> 2026-04 架构更新：以下规则优先于全文旧内容。装配不再按固定模板章次，而是按 `workspace/outputs/<project-slug>/00-section-plan.md` 的章节顺序装配。
>
> 当前装配规则：
> - 只装配用户要求的章节、表格、图示
> - 输出到 `workspace/assembled/<project-slug>/`
> - 装配后必须再做 final review

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- 用户要求“合稿”“总稿”“正式稿”“交付稿”
- 正文、表格、图示已经齐备，且 review / revise 已完成
- 你准备把中间产物装配成一份连续、完整、可交付的正式总稿

## 核心目标

把分散在 `workspace/outputs/`、`workspace/tables/`、`workspace/figures/` 的中间产物装配为一份正式总稿。
没有这一步，项目只能得到“工作区产物包”，不能得到完整交付稿。

正式装配的目标不是“把所有散件简单拼在一起”，而是得到一份阅读流与模板一致的连续成稿。
因此，文末统一附上“附图 / 附表”不能替代章节内装配。

## 使用前必读

开始装配前，至少读取以下文件：
- `workspace/plan/<project-slug>/project-brief.md`
- `workspace/outputs/<project-slug>/00-section-plan.md`
- `workspace/review/<project-slug>/review.md`
- 最近一轮 `revise` 结果说明
- 当前要纳入装配的 `workspace/outputs/<project-slug>/`、`workspace/tables/<project-slug>/`、`workspace/figures/<project-slug>/` 文件

## 输出目录

输出到：
- `workspace/assembled/<project-slug>/formal-draft.md`
- `workspace/assembled/<project-slug>/assembly-notes.md`

这是唯一允许的正式装配路径。
不要写到以下位置：
- `workspace/outputs/<project-slug>/assembled/`
- `workspace/outputs/<project-slug>/assembled/full-document.md`
- 任何未位于 `workspace/assembled/<project-slug>/` 下的“总稿”或“final”文件

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
- 装配输出的一级标题必须使用 `00-section-plan.md` 的 `正式输出标题`，不得使用 `用户章节标记`。例如正式输出标题为 `一、概述` 时，formal-draft 中不得写成 `# 第一章 概述`
- 装配前后必须逐章核对二级节清单。formal-draft 中出现 `00-section-plan.md` 未登记的二级节时，装配失败，应回到 revise 将内容并入既有小节或删除
- 若 `project-brief.md` 或 `00-section-plan.md` 中存在章次数量自相矛盾、原始标记跳号未说明、正式输出标题缺失等问题，不得装配，应先回到 using-official-docs / revise 修正计划
- 以正文章节文件为主线进行拼装
- 在正文引用位附近插入对应表格 / 图示内容，不要只保留孤立文件路径
- 不要把所有图表统一堆到文末“附图 / 附表”区来代替章节内插入；如需保留文末目录，只能作为补充，不得替代正文附近装配
- 若正文中仍有 `此处引用表X`、`此处插入图X`、`待插图表` 之类占位，装配时必须消除，占位未清零不得视为完成
- `workspace/outputs/`、`workspace/tables/`、`workspace/figures/` 中的最新文件是装配唯一数据源；装配时不得凭记忆重写正文、表格或图示
- 已生成的表格在装配时应直接纳入其最新 `.md` 文件内容，不得在 `formal-draft` 中再手写一版简化表或回退成更多 `【待补】`
- 图表 caption、编号、术语必须与正文一致
- 若某章 brief 已指定“图1 / 表1 应出现在本章”，装配时必须按该章节要求落位，不能只在文末追加一次
- 装配完成后，不得直接结束流程；必须再对当前 `formal-draft` 执行一轮 final review
- 如果 review 中仍有未修复的 Must Fix，不能直接宣称“最终定稿”
- 如果高优先表图尚未齐备，不得进入装配
- 如果用户给出了总字数硬约束且当前稿件未满足，不得进入装配
- 如果正文仍明显保留列表化、加粗小标签或机械过渡词，不得进入装配
- 装配前必须运行 `scripts/style_check.ps1` 检查将要装配的散件或当前 `formal-draft`。若脚本输出 `Result: FAIL`，不得装配，也不得把 assembly-notes 写成“可装配正式稿”
- 装配前必须核对 `project-brief.md` 与 `00-section-plan.md` 中的全文编号方案；若散件中存在章内二级标题写成 `### 一、`、`### 二、` 而方案要求 `（一）`、`（二）`，不得装配
- 若正式报告型方案下散件或 formal-draft 出现 `# 第一章`、`# 第二章` 等章标题，或普通章节出现 `#### 11.1`、`#### 13.2` 等十进制标题，均不得装配
- 装配时要优先纳入 brief 与 `00-section-plan.md` 中要求的表图
- 若正式稿中的任一表图内容与对应散件文件不一致，必须视为装配失败并回到 revise / assemble 修复
- 若正式稿仍包含未核验的高风险具体事实，不能用 assemble 掩盖该问题，必须回到 revise / review 修复

## 装配前判定

装配前必须先给出结论：
- `可装配正式稿`
- `暂不可装配`

判定口径如下：
- 若全书必需章节已齐、Must Fix 已清、高优先表图已齐、review / revise 已完成，可装配正式稿
- 若仍缺必需章节正文、高优先表图、存在未修复 Must Fix、review / revise 尚未完成，或总字数未满足用户要求，则暂不可装配
- 若当前 `assembly-notes` 的字数、比例、`【待补】` 数与当前 `formal-draft` 不一致，也不得判为正式稿
- 若表图尚未装配到对应章节附近、正文仍保留引图引表占位，暂不可装配

## 装配后强制动作

装配完成后，必须立即执行以下动作：
1. 重新读取当前 `workspace/assembled/<project-slug>/formal-draft.md`
2. 基于当前 `formal-draft` 重新计算章节比例与 `【待补】` 数
3. 检查是否仍残留 `此处引用表X`、`此处插入图X`、文末统一附图附表替代章节装配等问题
4. 立即调用 `official-doc-review` 做一轮 final review
5. 生成 `workspace/review/<project-slug>-final-review.md`
6. 仅当 final review 未发现新的 Must Fix 时，才允许把装配结果标记为“可装配正式稿”

final review 中关于调研来源数、style_check 结果和编号方案的结论必须来自当前文件实时检查；若 final review 与脚本输出或 `research-sources.md` 实际来源数矛盾，以脚本输出和实际来源数为准，assembly-notes 必须记录“需回退 revise / research”，不得写“可保留为正式交付稿”。

不要把装配前的 review 直接沿用为装配后的最终判断。

## 装配定位规则

- 按 `00-section-plan.md` 的章节顺序装配
- 表图按正文引用位置或章节要求就近插入
- 若 brief 已明确某张表或图属于某一章，必须在该章附近落位
- 若散件表格或图示已含明确值，装配稿不得回退成更空的占位版本
- 若 `formal-draft.md` 末尾仅追加一整段“附图 / 附表”，而对应章节附近没有插入图表，默认视为装配不合格

## 交付后动作

- 更新 `workspace/plan/progress.md`
- 如果装配稿仍存在明显缺口，回写 `workspace/review/` 或 `workspace/plan/`，不要假装已经完全定稿
- 更新 `workspace/assembled/<project-slug>/assembly-notes.md` 时，所有章节比例、`【待补】` 数和装配判定都必须基于当前 `formal-draft` 重新计算，不得沿用旧 review 中已经过期的统计值
- `assembly-notes` 的章节比例和 `【待补】` 统计方法必须与 `workspace/review/<project-slug>-final-review.md` 完全一致
- 在 `workspace/plan/progress.md` 中明确记录：是否已完成装配后 final review，以及 final review 的结论
- 若用户给出了总字数要求，还必须在 `assembly-notes` 和 `progress.md` 中记录“目标总字数 / 当前总字数 / 是否达标”
- 在 `workspace/assembled/<project-slug>/assembly-notes.md` 中写明 final review 文件路径：`workspace/review/<project-slug>-final-review.md`
