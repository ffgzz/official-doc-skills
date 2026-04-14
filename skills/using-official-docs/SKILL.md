---
name: using-official-docs
description: Use when the user asks to write, continue, revise, expand, add tables, add figures, review, assemble, or deliver either ZS-项目可行性报告 or 完整科研项目模板, even if the user only gives the document type and a materials path
allowed-tools: Read Write Edit Bash
---

<SUBAGENT-STOP>
如果你是作为子代理被派发执行一个已经明确的单点任务，例如“只生成一张表”或“只复核一个文件”，可以跳过本入口技能。
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
对以下两类文档，入口流程是强制的：
1. `ZS-项目可行性报告`
2. `完整科研项目模板`

只要用户的任务与这两类文档相关，你就必须优先遵循本技能。
即使用户只说“我要写 ZS-项目可行性报告，材料在 materials/test-case-zs/”，你也不能直接自由发挥；必须先按本技能完成路由和初始化。
</EXTREMELY-IMPORTANT>

## 这个入口技能解决什么问题

用户不需要再写很长的流程提示词。

用户通常只需要提供：
- 文档类型
- 材料目录或材料文件
- 当前诉求（例如：开始写、继续推进、补表、补图、复核、合稿）

你要负责把这三个输入自动展开成完整流程。

## 默认用户输入模式

### 模式 A：开始新写作

例如：
- `我要写 ZS-项目可行性报告，材料在 materials/test-case-zs/`
- `我要写 完整科研项目模板，材料在 materials/test-case-full/`

你要自动完成：
1. 判定模板
2. 初始化或复用工作区
3. 读取对应模板文件
4. 加载通用规则
5. 路由到对应主 Skill
6. 生成骨架和正文初稿
7. 在合适阶段主动衔接表格、图示、复核

### 模式 B：继续推进已有任务

例如：
- `继续推进 ZS-项目可行性报告，材料还是 materials/test-case-zs/`
- `继续写完整科研项目模板，还是用 materials/test-case-full/`

你要自动完成：
1. 识别已有工作区状态
2. 读取已生成的 outputs/tables/figures/review/assembled/plan
3. 选择下一阶段最合理的子任务继续做

### 模式 C：单点需求但仍属于这两类公文

例如：
- `给 ZS-项目可行性报告补表`
- `给完整科研项目模板补图`
- `检查这份 ZS-项目可行性报告`
- `把这份 ZS-项目可行性报告合成正式总稿`

你仍然要先判定当前模板和当前阶段，然后路由到对应公共 Skill。

## 路由规则

### 1. 判定主模板

满足任一条件，路由到 `zs-feasibility-report`：
- 用户明确提到 `ZS-项目可行性报告`
- 用户明确提到 `ZS`
- 当前任务明显是围绕 10 个固定一级章节的中型项目可行性报告

满足任一条件，路由到 `full-research-template`：
- 用户明确提到 `完整科研项目模板`
- 用户明确提到“大模板”或“完整模板”且上下文对应当前插件支持的那一套模板
- 当前任务是大体量项目申报材料，需要按章节批次推进

### 2. 判定是否需要公共 Skill

满足任一条件，主动调用 `official-doc-table`：
- 当前阶段要补表
- 正文中已出现表格引用位但表文件未生成
- 当前章节明显依赖任务表、成员表、预算表、成果表等

满足任一条件，主动调用 `official-doc-figure`：
- 当前阶段要补图
- 正文中已出现图示引用位但图文件未生成
- 技术路线、组织架构、任务分解、进度逻辑需要图示承载

满足任一条件，主动调用 `official-doc-review`：
- 用户要求检查、复核、定稿前核验
- 当前批次正文/表图已生成，需要做一致性检查
- 你准备声称“这一轮已完成”

满足任一条件，主动调用 `official-doc-revise`：
- `official-doc-review` 已识别出需要修复的问题
- 用户要求“修改”“回修”“按复核意见调整”
- 你准备进入正式总稿装配，但当前草稿仍存在未处理问题

满足任一条件，主动调用 `official-doc-assemble`：
- 用户要求“合稿”“总稿”“正式稿”“交付稿”
- 当前正文、表格、图示已经齐备，且复核/回修已完成
- 你准备交付本轮正式成稿，而不是继续停留在中间产物

## 强制流程

### 第一步：读取当前任务最小信息

至少锁定：
- 文档类型
- 材料位置
- 当前诉求

如果用户没说当前诉求，默认按“开始新写作”处理。

### 第二步：初始化或复用工作区

确保以下目录存在：

```text
plan/
outputs/
tables/
figures/
review/
assembled/
```

确保以下文件存在：
- `plan/project-overview.md`
- `plan/source-materials.md`
- `plan/facts-ledger.md`
- `plan/progress.md`

如果不存在，就创建；如果已存在，就复用并更新。

### 第三步：读取模板文件

#### ZS-项目可行性报告 必读
- `templates/zs-feasibility-report/outline.md`
- `templates/zs-feasibility-report/source-checklist.md`
- `templates/zs-feasibility-report/writing-playbook.md`
- `templates/zs-feasibility-report/table-catalog.md`
- `templates/zs-feasibility-report/figure-catalog.md`

#### 完整科研项目模板 必读
- `templates/full-research-template/outline.md`
- `templates/full-research-template/source-checklist.md`
- `templates/full-research-template/writing-playbook.md`
- `templates/full-research-template/chapter-splitting-plan.md`
- `templates/full-research-template/table-catalog.md`
- `templates/full-research-template/figure-catalog.md`

### 第四步：加载通用规则

在推进正文之前，你必须调用 `official-doc-core` 这一 skill 。绝不能跳过此调用自行脑补：
- 固定标题不乱改
- 事实不编造
- 缺失信息写 `【待补】`
- 台账必须回写
- 表图独立生成
- 正式交付前必须经过 `review -> revise -> assemble`

### 第五步：调用主 Skill

本入口技能不负责生成正文！你必须使用 Skill 工具调用对应的主 Skill，将正文生成的控制权交接出去：
- 写 `ZS-项目可行性报告` → `zs-feasibility-report`
- 写 `完整科研项目模板` → `full-research-template`

### 第六步：阶段完成后主动推进后续 Skill

不要等用户显式说：
- “现在去生成表格”
- “现在去画图”
- “现在去复核”
- “现在去修改”
- “现在去合总稿”

如果当前阶段已经明显需要这些动作，你应主动继续。

默认闭环为：
1. 正文与表图成型后，先调用 `official-doc-review`
2. 如果 review 中存在可修复问题，继续调用 `official-doc-revise`
3. 需要对外提交或形成完整成稿时，再调用 `official-doc-assemble`

不要停在 `review/` 目录里就声称任务已经完成。

### 默认补表补图顺序

#### 对 ZS-项目可行性报告

正文推进时默认按以下顺序衔接公共 Skill：
1. 第4章稳定后：`official-doc-figure` 先补 `图1`，`official-doc-table` 再补 `表1`
2. 第5章稳定后：补 `表2`
3. 第7章稳定后：补 `表3`、`表4`
4. 第8章稳定后：补 `表5`
5. 第9章稳定后：补 `表6`

#### 对 完整科研项目模板

正文推进时默认按以下顺序衔接公共 Skill：
1. 第3章稳定后：先补团队类高优先表，并补 `图3-2 项目组织架构图`
2. 第4章稳定后：优先补 `图4-1`、`图4-2`、`图4-5` 以及第4章高优先成果/任务类表
3. 第8章稳定后：补资金来源结构表、分年度投资安排表、主要投资估算表
4. 只有当第4章下钻到专题层级时，再补扩展验证类图表

不要把“补表补图”理解成最后统一做一次；它应跟随正文阶段逐步推进。

## 用户无需再提供的内容

以下内容不应再作为默认追问：
- “请提供参考样稿让我学习风格”
- “请告诉我先初始化工作区”
- “请告诉我先读 outline”
- “请告诉我是否要先生成骨架”
- “请告诉我是否要先合稿”

这些都属于本 Skill 内部流程。

## 你对用户的默认响应方式

当用户只给出“文档类型 + 材料目录”时，你应直接进入执行，不要先讲一大段流程说明。

更好的响应方式是：
1. 简短确认已锁定的模板和材料位置
2. 直接开始创建或更新工作区
3. 读取模板文件
4. 开始产出第一批结果

## Red Flags

| 错误想法 | 正确做法 |
|---|---|
| “用户没说流程，我就直接自由写一篇” | 先按本入口技能完成路由 |
| “既然已经有材料目录，就不用读取模板文件” | 模板文件是强制读取项 |
| “用户没提表图，那我不管” | 需要时要主动调用表图 Skill |
| “用户没提复核，那我不做检查” | 准备交付时必须主动复核 |
| “复核做完就算结束了” | 还要继续 `revise -> assemble` 才算到交付 |
| “没有参考样稿我就不知道风格” | 风格和结构优先来自模板与对应主 Skill |
