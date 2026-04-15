---
name: official-doc-writing-skill
description: Use when drafting formal Chinese project materials from a prompt-only brief. The plugin parses a topic plus chapter requirements, routes five recurring chapter types to dedicated skills, drafts other chapters directly, and coordinates tables, figures, review, revise, and assembly.
---

# 公文项目写作助手

这是一个“按共性章节能力拆分”的正式项目材料写作插件，不再按固定公文模板拆分。

## 当前架构

- 入口统筹：`using-official-docs`
- 通用规则：`official-doc-core`
- 共性章节：
  - `official-doc-project-background`
  - `official-doc-research-content`
  - `official-doc-innovation`
  - `official-doc-technical-achievements`
  - `official-doc-technical-indicators`
- 公共流程：
  - `official-doc-table`
  - `official-doc-figure`
  - `official-doc-review`
  - `official-doc-revise`
  - `official-doc-assemble`

## 适用输入

用户通常只需提供一段提示词，说明：
- 主题
- 要写哪些章节
- 每章要写什么
- 每章需要哪些表格和图示
- 每章或全文字数

## 核心原则

- 先解析 brief，再写作
- 共性章节按能力 skill 写，非共性章节直接写
- 五类共性章节必须先做网络搜索
- 技术成果必须由研究内容推出
- 技术指标必须可量化、可测试
- 最终交付要经过 review / revise / assemble
