---
name: official-doc-figure
description: Use when the current official-document workflow explicitly or implicitly needs figures for ZS-项目可行性报告 or 完整科研项目模板 - generates caption-aligned diagrams and figure notes without requiring the user to ask separately
allowed-tools: Read Write Edit Bash
---

# 公文图示 Skill

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

## 输出格式

- `figures/<template>/<figure-file>.mmd`
- `figures/<template>/<figure-file>.md`
- 可选：`figures/<template>/<figure-file>-svg-spec.md`

## 强制规则

- 图名 caption 与模板目录一致
- 节点名称与正文术语一致
- 一张图只表达一个主逻辑
- 没有精确数据时，不伪造数值型图表
- 图示说明稿要解释“这张图回答什么问题”
- 更新 `plan/progress.md`

## ZS-项目可行性报告优先图示

优先图示：
- 图1 技术路线图

推荐逻辑：
数据采集与整理 → 核心对象建模 → 规则/算法处理 → 结果生成 → 一致性校核 → 人工复核 → 交付输出

## 完整科研项目模板优先图示

优先图示：
- 项目建设总体目标概念图
- 项目主要建设任务分解图
- 项目整体技术路线图
- 组织架构图
- 系统架构图

## 交付前检查

- 图名与正文引用一致
- 节点顺序与正文逻辑一致
- 没有正文中不存在的陌生阶段
