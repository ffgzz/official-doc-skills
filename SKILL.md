---
name: official-doc-writing-skill
description: 正式中文项目公文写作插件总入口。只要用户要求撰写或继续撰写项目可行性报告、立项申请书、项目建议书、攻关任务书、技术总结等正式项目文稿，就必须先使用本插件，而不是先直接联网搜索或直接起草正文。典型触发提示包括：“请使用official-doc-writing-skill”“围绕某主题写一份正式项目可行性报告”“按以下章节顺序生成”“每章需要写什么、有哪些图表、字数要求”“切记深度调研”。本插件会先调用 using-official-docs，再进入 official-doc-core、official-doc-research 和各章节 skill。
---

# 公文项目写作助手

这是一个“按共性章节能力拆分”的正式项目材料写作插件，不再按固定公文模板拆分。

<EXTREMELY-IMPORTANT>
只要用户消息是在要求生成正式项目公文，不论用户是否同时要求“先深度调研”“先搜索公开资料”“按章节顺序生成”，都必须先进入本插件。

禁止行为：
- 还没加载本插件就直接联网搜索
- 还没进入 `using-official-docs` 就直接开始写正文
- 因为用户写了“切记深度调研”就绕过插件、按默认搜索流程执行
</EXTREMELY-IMPORTANT>

## 当前架构

- 入口统筹：`using-official-docs`
- 通用规则：`official-doc-core`
- 独立调研门禁：`official-doc-research`
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
- 五类共性章节先过 `official-doc-research` 调研门禁，再按能力 skill 写
- 非共性章节直接写
- 调研默认优先近 3 年资料，不得只搜两三次就停
- 技术成果必须由研究内容推出
- 技术指标必须可量化、可测试
- 最终交付要经过 review / revise / assemble
