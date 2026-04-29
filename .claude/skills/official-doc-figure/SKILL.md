---
name: official-doc-figure
description: 用于生成项目公文所需图示。它只补用户要求的图，依据章节逻辑和调研证据生成图示内容，并输出 mermaid 及图示说明供后续装配。
allowed-tools: Read Write Edit Bash
---

# 公文图示 Skill

> 当前图示流程只依据：
> - `project-brief.md`
> - `source-materials.md`
> - `00-section-plan.md`
> - 当前章节正文
> - 已登记的研究来源、调研证据档案与事实台账

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- 用户明确说要补图
- 当前正文已出现图示引用位
- 技术路线、组织架构、任务分解、进度安排等逻辑更适合图示表达
- 入口 Skill 或主 Skill 判断当前下一步最合理的是补图

## 核心目标

把需要单独表达的结构化逻辑生成为：
- Mermaid 图源
- 图示说明稿
- 必要时的 SVG 说明规范

## 使用前必做

1. 读取 `workspace/plan/<project-slug>/project-brief.md`
2. 读取 `workspace/plan/<project-slug>/source-materials.md`
3. 读取 `workspace/outputs/<project-slug>/00-section-plan.md`
4. 读取当前章节正文
5. 核对正文里该图的引用位置和术语
6. 核对 `research-sources.md`、`research-evidence.md` 与 `facts-ledger.md` 中是否已有可支撑该图结构的依据

若图示表达的是项目技术路线、系统架构、任务分解、单位分工、应用推广或进度安排，应优先从 `source-materials.md` 和 USER 系列事实记录中抽取节点、层级、模块和流向；外部调研只能补充行业趋势或通用方法，不得替换用户已给出的项目链路。

## 选择逻辑

### 先决定“补哪张图”

默认按以下顺序判断：
1. 用户在 brief 中明确要求的图
2. `00-section-plan.md` 中已登记的图
3. 当前正文已出现引用位的图
4. 当前章节最需要图示表达的结构化逻辑

### 再决定“画到什么层级”

默认按以下信息来定：
- 所属章节
- 图的用途
- 当前章节已经出现的关键节点或阶段
- 与正文配套的引用关系

不要脱离正文，凭空画一张泛化流程图。

## 输出格式

- `workspace/figures/<project-slug>/<figure-file>.mmd`
- `workspace/figures/<project-slug>/<figure-file>.md`
- 可选：`workspace/figures/<project-slug>/<figure-file>-svg-spec.md`

## 强制规则

- 图名 caption 与模板目录一致
- 图名 caption 与用户 brief 或 `00-section-plan.md` 一致
- 节点名称与正文术语一致
- 一张图只表达一个主逻辑
- 没有精确数据时，不伪造数值型图表
- 图示说明稿要解释“这张图回答什么问题”
- 更新 `workspace/plan/progress.md`
- 图型要服务当前图的目的，不要把不同问题都画成同一种图
- 如果正文主要强调目标分解，优先用树状分解图
- 如果正文主要强调流程先后，优先用流程图
- 如果正文主要强调模块关系，优先用架构图或关系图
- `.mmd` 图源在宣布完成前必须通过 Mermaid 语法校验；至少运行一次 `python scripts/check_mermaid.py <figure-file>.mmd`
- 未通过校验的图不得写成“已完成”，也不得进入装配
- `subgraph` 与 `end` 必须各自单独成行，禁止写成 `..."] end subgraph_xxx` 这类会直接触发 Mermaid 解析错误的形式
- 图示说明稿不得出现 `【来源：...】`、内部来源编号或调研映射说明；证据只用于确定图结构，不得裸露到正式说明稿
- 若图中节点文本过长，应通过换行或拆分节点解决，不得为了省事把多层逻辑塞进一个节点导致图无法解析

## 图示说明稿要求

每个 `.md` 说明稿建议至少包含：
1. 图 caption 与所属章节
2. 当前图的用途
3. 这张图回答的核心问题
4. 节点流转说明
5. 与正文的对应关系
6. 装配提示
7. 当前采用的图型 / 拓扑（树状分解图、流程图、矩阵图等）
8. 若图型选择存在取舍，说明理由

## 与章节的关系

- 图示应服务当前章节论证，而不是为了凑页数
- 若用户只要求少量图，不要自行扩图
- 若某章没有图示需求，不要硬补一张泛化图

## 交付前检查

- 图名与正文引用一致
- 节点顺序与正文逻辑一致
- 没有正文中不存在的陌生阶段
- 图的用途与所在章节匹配
- 说明稿已写清与正文的对应关系
- `.mmd` 已通过 `scripts/check_mermaid.py`
- `progress.md` 已记录校验结果；若校验未通过，必须记录为阻断项而不是伪装成完成
