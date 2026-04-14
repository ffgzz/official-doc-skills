# 公文项目写作助手（Plugin 版）

这是一个面向 **Claude Code 插件模式** 的公文写作 Skill 包。它借鉴了 `research-writing-skill` 的两层关键设计：

1. **插件根目录 + skills 子目录 + hooks 自动注入入口技能**
2. **入口 Skill 负责流程门禁，主 Skill/公共 Skill 负责分工执行**

## 当前支持范围

- `ZS-项目可行性报告`
- `完整科研项目模板`

## 架构

```text
official-doc-writing-skill/
├─ .claude-plugin/plugin.json
├─ hooks/
│  ├─ hooks.json
│  ├─ run-hook.cmd
│  ├─ session-start.ps1
│  └─ session-start
├─ skills/
│  ├─ using-official-docs/
│  ├─ zs-feasibility-report/
│  ├─ full-research-template/
│  ├─ official-doc-core/
│  ├─ official-doc-table/
│  ├─ official-doc-figure/
│  ├─ official-doc-review/
│  ├─ official-doc-revise/
│  └─ official-doc-assemble/
├─ templates/
├─ plan-template/
├─ materials/
└─ scripts/
```

## 你应该怎样理解这套插件

这不是“点一下就出 Word”的工具，而是：

- 自动把入口 Skill 注入当前会话
- 先判定你要写哪种模板
- 强制读取模板结构和资料清单
- 再路由到对应主 Skill
- 表、图、复核、修订、总稿装配分别用独立 Skill 处理

## 本地测试方式

在插件根目录执行：

```bash
claude --plugin-dir .
```

启动后先执行：

```text
/reload-plugins
```

然后可以直接测试：

```text
/official-doc-writing-skill:using-official-docs
当前任务：ZS-项目可行性报告。
输入材料：materials/test-case-zs/
请初始化工作区并开始正文骨架。
```

## 推荐测试顺序

1. `using-official-docs`：初始化、判定模板、建立工作区
2. `zs-feasibility-report`：跑一版正文初稿
3. `official-doc-table`：生成表格
4. `official-doc-figure`：生成图示
5. `official-doc-review`：做结构化复核
6. `official-doc-revise`：按问题清单回修
7. `official-doc-assemble`：输出正式总稿

## materials 目录说明

- `materials/test-case-zs/`：已内置一套用于 ZS 可行性报告的测试材料
- `materials/test-case-full/`：预留给完整科研项目模板的测试材料

## 重要边界

1. 默认产物仍以 `md`、`mmd`、说明文件为主，但现在应继续装配为 `assembled/` 下的正式总稿。
2. 一级、二级标题默认按模板固定。
3. 表图不内嵌在正文 Skill 里随手生成。
4. 预算、时间、单位、成果指标一律不得编造。
5. `plan/`、`outputs/`、`tables/`、`figures/`、`review/`、`assembled/` 都是运行时目录，其中 `plan/` 应由 `plan-template/` 初始化生成，不作为静态模板目录维护。
