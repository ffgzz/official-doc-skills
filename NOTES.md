# 设计备注

## 为什么这次改成 plugin + hooks

之前仅有 `skills/` 和根级 `SKILL.md`，Claude Code 并不会稳定把入口 Skill 自动读进当前会话，导致：

- 明明存在多个 Skill，却常常只用到一个叶子 Skill
- 模型不容易先读入口路由规则
- “主 Skill + 公共 Skill”的协同效果不稳定

现在参考 `research-writing-skill`，增加了 `SessionStart` hook：
会话开始时自动注入 `using-official-docs` 的完整内容，从而把“先走入口、再走子 Skill”的门禁规则前置。

## 当前架构

- 入口 Skill：`using-official-docs`
- 主 Skill：`zs-feasibility-report`、`full-research-template`
- 公共 Skill：`official-doc-core`、`official-doc-table`、`official-doc-figure`、`official-doc-review`、`official-doc-revise`、`official-doc-assemble`
