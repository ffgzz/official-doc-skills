---
name: official-doc-writing-skill
description: Use when drafting formal Chinese project materials based on fixed templates - routes between entry workflow, template-specific writing, tables, figures, review, revise, and assemble
allowed-tools: Read Write Edit Bash
version: 0.3.0
---

# 公文项目写作助手

把“写公文”从一次性聊天，升级成**有入口、有路由、有主技能、有公共技能、有台账记录**的工程化协作流程。

## 当前优先支持

1. `ZS-项目可行性报告`
2. `完整科研项目模板`

## 架构总览

### 入口 Skill

- `using-official-docs`：会话入口、流程门禁、模板判定、初始化工作区、路由到主 Skill 或公共 Skill

### 主 Skill

- `zs-feasibility-report`：面向 ZS 可行性报告的定制化写作 Skill
- `full-research-template`：面向完整科研项目模板的定制化写作 Skill

### 公共 Skill

- `official-doc-core`：通用公文规则、标题约束、事实纪律、台账规则
- `official-doc-table`：表格生成与口径说明
- `official-doc-figure`：图示生成与说明
- `official-doc-review`：一致性检查与修订清单输出
- `official-doc-revise`：按复核清单回修正文、表格、图示
- `official-doc-assemble`：把正文、表格、图示装配为正式总稿

## 核心原则

- **模板优先于自由发挥**：先锁定模板，再开始写正文。
- **一级标题优先于语言润色**：不擅自改模板固定标题。
- **事实优先于修辞**：无依据内容统一写 `【待补】`。
- **表图独立生成**：正文只保留引用位，表图由独立 Skill 产出。
- **先骨架后填充**：先生成结构，再逐章推进，再补表图，再复核、修订、装配。
- **交付必须装配**：`outputs/`、`tables/`、`figures/` 只是中间产物，最终还要产出 `assembled/` 正式总稿。
- **可回写、可追踪**：所有阶段都要回写 `plan/`、`outputs/`、`tables/`、`figures/`、`review/`、`assembled/`。

## 标准流程

1. 入口路由 → `using-official-docs`
2. 通用规则对齐 → `official-doc-core`
3. 模板正文推进 → `zs-feasibility-report` 或 `full-research-template`
4. 表图补全 → `official-doc-table` / `official-doc-figure`
5. 结构化复核 → `official-doc-review`
6. 定向修订 → `official-doc-revise`
7. 正式装配 → `official-doc-assemble`

## Red Flags（出现就停下检查）

| 错误想法 | 正确做法 |
|---|---|
| “先写一版再对模板” | 必须先读对应 `templates/<template>/outline.md` |
| “图表不多，正文里顺手带掉” | 表图必须独立生成 |
| “材料缺一点，我先补个数字” | 没有依据就写 `【待补】` |
| “完整科研项目模板太大，先一口气写完” | 只能按阶段、按章节推进 |
| “既然是可行性报告，章节名我帮他改顺一点” | 一级、二级标题默认不改 |
| “台账后面再补” | 任何缺口、口径冲突都要立即回写 `plan/` |

## 目录约定

```text
plan/
outputs/
tables/
figures/
review/
assembled/
templates/
materials/
```

其中：
- `templates/` 是静态模板来源
- `plan/` 及其它产出目录是运行时工作区，应在执行时动态创建

## 会话启动机制

本插件仿照 `research-writing-skill` 的做法，提供 `SessionStart` hook：
会话启动时自动注入入口 Skill 的规则，使模型先读入口再决策，而不是直接忽略 `skills/` 目录。
