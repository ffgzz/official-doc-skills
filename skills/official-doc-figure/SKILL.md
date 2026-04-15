---
name: official-doc-figure
description: Use when the user brief or a drafted chapter requires project figures. This skill generates only the requested diagrams for the current project slug, using chapter logic and research evidence instead of fixed template catalogs, and outputs mermaid plus figure notes for later assembly.
allowed-tools: Read Write Edit Bash
---

# 公文图示 Skill

> 2026-04 架构更新：以下规则优先于全文旧内容。旧的模板固定图目录、优先图清单、固定编号逻辑不再默认适用。
>
> 当前只做三件事：
> - 读取 `project-brief.md`、`00-section-plan.md`、当前章节正文
> - 生成用户明确要求的图示
> - 输出到 `workspace/figures/<project-slug>/`

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
5. 核对 `research-sources.md` 中是否已有可支撑该图结构的公开依据

## 选择逻辑

### 先决定“补哪张图”

默认按以下顺序判断：
1. catalog 中标为“必出”或“高优先”的图
2. 当前正文已出现引用位的图
3. 当前最重章节所需要的图
4. 用户明确点名要求的图

### 再决定“画到什么层级”

默认按 catalog 中给出的信息来定：
- 所属章节
- 作用
- 推荐节点
- 正文配套关系
- 扩展与否

不要跳过 catalog 中的节点建议，直接凭空画一张泛化流程图。

## 输出格式

- `workspace/figures/<template>/<figure-file>.mmd`
- `workspace/figures/<template>/<figure-file>.md`
- 可选：`workspace/figures/<template>/<figure-file>-svg-spec.md`

## 强制规则

- 图名 caption 与模板目录一致
- 节点名称与正文术语一致
- 一张图只表达一个主逻辑
- 没有精确数据时，不伪造数值型图表
- 图示说明稿要解释“这张图回答什么问题”
- 必须优先服从 catalog 中的“位置、作用、推荐节点、正文配套”
- 更新 `workspace/plan/progress.md`
- 如果 catalog 已给出默认拓扑或 Mermaid 骨架，优先按骨架生成，不要擅自换图型
- 若生成图的拓扑与 catalog 不一致，必须在说明稿中写出偏离理由

## ZS-项目可行性报告优先图示

- 图1 技术路线图为固定必出图
- 它必须服务第4章 `（一）项目技术路线`
- 默认拓扑以 catalog 为准：优先采用“总目标 -> 子课题 1 / 2 / 3 -> 子任务”的树状分解图
- 只有当正文明确要求强调流程先后关系时，才允许退化成线性 pipeline
- 图1必须与表1形成“路线 + 任务”的配对关系，不要用图1替代表1

## 完整科研项目模板优先图示

第一轮优先图默认包括：
- 图2-1 项目建设总体目标概念图
- 图2-2 项目主要建设任务分解
- 图2-3 项目整体技术路线图
- 图2-4 关键系统平台架构图
- 图4-1 项目组织与实施管理架构图

默认图型建议：
- 图2-1 优先采用“总体目标 -> 分目标 -> 支撑能力”的目标分解图
- 图2-2 优先采用任务树 / WBS 分解图
- 图2-3 优先采用“输入条件 -> 关键任务链 -> 平台/系统 -> 成果输出”的路线图
- 图2-4 优先采用平台分层 / 模块关系图
- 图4-1 优先采用组织树 / 责任分层图

强制要求：
- 不要把大模板的高优先图都画成同一种通用 pipeline
- 图2-1、图2-2、图2-3、图2-4、图4-1 应回答不同问题，图型应区分
- 若第2章已经形成较强任务体系，图2-2 和图2-3 不得合并成一张“泛化路线图”敷衍处理

中优先图仅在正文已经形成稳定内容时再补：
- 产业链位置与建设必要性示意
- 工程应用场景图
- 财务测算逻辑框图

扩展专题图仅在第4章已经下钻到专题层级时再补：
- 子任务建设路线图
- 业务流程图 / 送审流程图 / 退审流程图
- 数据模型 / 知识图谱 / 一致性维护技术路线图
- 测试验证流程图 / 测试平台架构图

## 图示说明稿要求

每个 `.md` 说明稿建议至少包含：
1. 图 caption 与所属章节
2. catalog 规定的优先级和用途
3. 这张图回答的核心问题
4. 节点流转说明
5. 与正文的对应关系
6. 装配提示
7. 当前采用的图型 / 拓扑（树状分解图、流程图、矩阵图等）
8. 若未采用 catalog 默认骨架，说明偏离理由

## 与章节配比的关系

- 对 ZS，图示主要服务第4章，不向第7章到第9章扩散
- 对大模板，图示优先服务第2章，其次才是第4章和第1章
- 偏短章节默认不靠增加图示来“凑厚度”

## 交付前检查

- 图名与正文引用一致
- 节点顺序与正文逻辑一致
- 没有正文中不存在的陌生阶段
- 已遵守 catalog 中的优先级与节点建议
- 对 ZS 的图1，优先检查是否与第3章子课题结构同构
- 若 ZS 图1被画成通用 pipeline，应核对是否有充分理由
