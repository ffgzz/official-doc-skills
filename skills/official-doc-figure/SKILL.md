---
name: official-doc-figure
description: Use when the user brief or a drafted chapter requires project figures. This skill generates only the requested diagrams for the current project slug, using chapter logic and research evidence, and outputs mermaid plus figure notes for later assembly.
allowed-tools: Read Write Edit Bash
---

# 公文图示 Skill

> 当前图示流程只依据：
> - `project-brief.md`
> - `00-section-plan.md`
> - 当前章节正文
> - 已登记的研究来源与事实台账

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
2. 读取 `workspace/outputs/<project-slug>/00-section-plan.md`
3. 读取当前章节正文
4. 核对正文里该图的引用位置和术语
5. 核对 `research-sources.md` 与 `facts-ledger.md` 中是否已有可支撑该图结构的依据

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
