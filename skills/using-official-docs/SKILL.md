---
name: using-official-docs
description: Use as the mandatory entry skill when the user wants to draft or continue a formal Chinese project document from a prompt-only brief. The brief usually gives a topic, which chapters to write, what each chapter must contain, required tables or figures, and word counts. This skill parses the brief, initializes the project workspace, applies official-doc-core, routes the five common section types to their dedicated skills, drafts all other sections directly, and then coordinates table, figure, review, revise, and assemble steps.
allowed-tools: Read Write Edit Bash
---

<SUBAGENT-STOP>
如果你是作为子代理被派发执行一个已经明确的单点任务，例如“只生成一张表”或“只复核一个文件”，可以跳过本入口技能。
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
2026-04 架构更新：以下规则覆盖全文，凡与下文旧模板规则冲突者，一律忽略旧规则。

1. 当前工作方式是“提示词驱动写作”，不是“材料目录 + 固定模板”。
2. 不再按 `ZS` 或 `完整科研项目模板` 做路由。
3. 不再依赖 `templates/` 目录，也不再要求用户先给 `materials/...`。
4. 你仍然是主统筹 skill，需要先解析：
   - 项目主题
   - project-slug
   - 章节顺序
   - 每章要写什么
   - 每章所需表格和图示
   - 每章或全文字数
5. 初始化或复用的目录改为：
   - `workspace/plan/<project-slug>/`
   - `workspace/outputs/<project-slug>/`
   - `workspace/tables/<project-slug>/`
   - `workspace/figures/<project-slug>/`
   - `workspace/review/<project-slug>/`
   - `workspace/assembled/<project-slug>/`
6. 必须维护的新计划文件为：
   - `project-overview.md`
   - `project-brief.md`
   - `research-sources.md`
   - `facts-ledger.md`
   - `progress.md`
   - `workspace/outputs/<project-slug>/00-section-plan.md`
7. 在任何正文写作前，仍必须单独执行一次 `official-doc-core`。
8. 只有以下五类共性章节才调用专项 skill：
   - `official-doc-project-background`
   - `official-doc-research-content`
   - `official-doc-innovation`
   - `official-doc-technical-achievements`
   - `official-doc-technical-indicators`
9. 其他章节不需要额外 skill，直接按用户 brief 写作。
10. 上述五类章节必须先做网络搜索并登记来源，不能瞎编。
11. 下文若继续出现旧模板、旧 materials、旧 templates、旧主 Skill 规则，全部仅作归档，不得执行。
</EXTREMELY-IMPORTANT>

## 触发样例

以下输入都应直接触发本技能：
- `围绕船舶智能设计平台，写项目背景、研究内容、创新点、主要技术成果和主要技术指标；背景要写建设背景、国内外现状、痛点和必要性，第2章要带技术路线图，总字数 8000 字。`
- `主题是 AI 原生船舶 PLM，写第1章项目背景、第2章研究内容、第5章技术指标，每章给出字数和表图建议。`
- `继续推进 current-project，把还没写完的章节、表图、review 接着做完。`

## 强制调度协议

本 Skill 仍然是“统筹入口”，但不再是旧模板路由器。

当前强制顺序改为：
1. 解析用户 brief
2. 生成或复用 `project-slug`
3. 初始化 `workspace/<kind>/<project-slug>/`
4. 写 `project-overview.md`、`project-brief.md`、`research-sources.md`、`facts-ledger.md`、`progress.md`
5. 写 `workspace/outputs/<project-slug>/00-section-plan.md`
6. 单独执行 `official-doc-core`
7. 判断每章是否命中五类共性章节 skill
8. 命中则调用专项 skill，未命中则直接按 brief 写
9. 再按需推进 table / figure / review / revise / assemble

本 Skill 允许直接做两类事：
- 统筹与计划文件写入
- 对“不属于五类共性章节”的章节直接写正文

本 Skill 不应继续执行下文任何旧的“模板判定”“模板必读文件”“固定模板顺序”规则。

# 入口 Skill 的职责边界

本 Skill 是调度层，不是正文规则层。

它只负责：
- 判定当前文档模板
- 识别当前任务模式
- 初始化或复用 `workspace/` 工作区
- 读取最少必要模板文件
- 判断当前阶段最合理的下一步
- 路由到主 Skill 或公共 Skill

它不负责：
- 重复主 Skill 的章节写法
- 重复 catalog 的表图细则
- 重复 review 的验收阈值

这些内容分别由以下文件负责：
- 正文规则：对应主 Skill 与 `templates/<template>/writing-playbook.md`
- 表格规则：`official-doc-table` 与 `table-catalog.md`
- 图示规则：`official-doc-figure` 与 `figure-catalog.md`
- 验收规则：`official-doc-review`

## 一、输入识别

至少锁定三件事：
- 文档类型
- 材料位置
- 当前诉求

若用户明确提到以下任一信息，也必须锁定并写入台账：
- 总字数
- 篇幅上限 / 下限
- “控制在 X 字左右”
- “不少于 X 字”
- “不超过 X 字”

若用户未说明当前诉求，默认按“开始新写作”处理。

## 二、任务模式

### 模式 A：开始新写作

本 Skill 应：
1. 判定模板
2. 初始化或复用工作区
3. 读取模板文件
4. 单独调用 `official-doc-core`
5. 路由到对应主 Skill
6. 停止以入口 Skill 身份继续扩写正文

### 模式 B：继续推进

本 Skill 应：
1. 读取已有 `workspace/plan/ workspace/outputs/ workspace/tables/ workspace/figures/ workspace/review/ workspace/assembled/`
2. 判断当前已到哪个阶段
3. 选择下一步最合理的 Skill

不要向用户反问：
- `下一步是先 review 还是先补章节？`
- `要不要先补表再继续？`
- `是先 revise 还是先 assemble？`

应由你根据当前文件状态严格按流程自动判断下一步。

### 模式 C：单点动作

例如补表、补图、复核、回修、合稿。

本 Skill 应：
1. 先判定当前模板
2. 再判定当前阶段
3. 单独调用 `official-doc-core`
4. 路由到对应公共 Skill
5. 停止以入口 Skill 身份继续执行该公共 Skill 的正文/表图内容

## 三、模板判定

满足任一条件，路由到 `zs-feasibility-report`：
- 用户明确提到 `ZS-项目可行性报告`
- 用户明确提到 `ZS`
- 当前任务明显围绕 10 个固定一级章节的中型可研报告

满足任一条件，路由到 `full-research-template`：
- 用户明确提到 `完整科研项目模板`
- 用户明确提到“大模板”或“完整模板”，且上下文对应本插件支持的那一套模板
- 当前任务是大体量项目申报材料，需要按单章顺序推进

## 四、工作区职责

必须确保以下目录存在：

```text
workspace/
  plan/
  outputs/
  tables/
  figures/
  review/
  assembled/
```

必须确保以下文件存在：
- `workspace/plan/project-overview.md`
- `workspace/plan/source-materials.md`
- `workspace/plan/facts-ledger.md`
- `workspace/plan/progress.md`

如果不存在，就创建；如果已存在，就复用并更新。

若用户提供了字数要求，必须在以下位置同步记录：
- `workspace/plan/project-overview.md`：记录“目标总字数 / 上下限 / 是否为硬约束”
- `workspace/plan/progress.md`：记录“当前目标总字数”和“当前阶段是否仍在目标范围内”

## 五、最少必读文件

### 对 ZS-项目可行性报告
- `templates/zs-feasibility-report/outline.md`
- `templates/zs-feasibility-report/writing-playbook.md`
- `templates/zs-feasibility-report/table-catalog.md`
- `templates/zs-feasibility-report/figure-catalog.md`

### 对 完整科研项目模板
- `templates/full-research-template/outline.md`
- `templates/full-research-template/writing-playbook.md`
- `templates/full-research-template/chapter-splitting-plan.md`
- `templates/full-research-template/table-catalog.md`
- `templates/full-research-template/figure-catalog.md`

正文细则不要在入口层重复解释。

## 六、强制调度顺序

### 新任务默认顺序
1. 判定模板
2. 初始化或复用工作区
3. 读取模板最少必要文件
4. 单独调用 `official-doc-core`
5. 调用对应主 Skill
6. 只有在主 Skill 已接管后，才允许生成 `workspace/outputs/...`

### 已有任务默认顺序
1. 读取当前状态
2. 判断最合理的下一步
3. 单独调用 `official-doc-core`
4. 路由到对应 Skill
5. 只有在对应 Skill 已接管后，才允许生成该阶段文件

## 七、下一步判断规则

入口层只判断“下一步做什么”，不重复“具体怎么做”。

默认判断如下：
- 若尚未形成正文骨架，进入对应主 Skill
- 若正文已成形但缺表，进入 `official-doc-table`
- 若正文已成形但缺图，进入 `official-doc-figure`
- 若当前章节正文和该章必要表图已齐，进入 `official-doc-review`
- 若 review 已给出问题，进入 `official-doc-revise`
- 若全书必需章节、必需表图、review / revise 均已完成且用户目标是交付，进入 `official-doc-assemble`

对 `完整科研项目模板`，若用户只是说“继续推进”，默认含义应是：
- 识别下一个未完成章节
- 路由到 `full-research-template`
- 只推进该章节，而不是跨多章连续生成

## 八、对用户的默认响应方式

当用户只给出“文档类型 + 材料目录”时：
- 简短确认模板和材料位置
- 直接开始执行
- 不要先输出长篇流程说明
- 不要把流程分支选择题再抛回给用户

当用户同时给出字数要求时：
- 把字数要求视为硬约束
- 后续正文、表图和正式稿都按该总字数目标控制
- 不要口头答应后又按默认篇幅生成

## 九、入口层不要做的事

- 不要在这里重复主 Skill 的章节写法
- 不要在这里重复表图 catalog 的字段和节点细则
- 不要在这里重复 review 的验收阈值
- 不要把入口层写成第二份 `writing-playbook`
- 不要一边要求路由，一边自己接管正文生成
- 不要在尚未切换到目标 Skill 前直接写 `chapter-*.md`、表格、图示、review 或 assembled 正稿
- 不要跳过 `official-doc-core` 直接进入主 Skill 或公共 Skill
- 不要把“下一步走 review 还是继续写章节”这类流程判断再反问给用户

## 十、Red Flags

| 错误想法 | 正确做法 |
|---|---|
| “用户没说流程，我就直接自由写一篇” | 先做模板判定和状态判断 |
| “入口层顺便把正文规则也讲一遍” | 正文规则交给主 Skill 和 playbook |
| “入口层顺便把表图怎么画怎么列表头都写了” | 表图细则交给 catalog 和公共 Skill |
| “入口层看到 review 就自己判定通过” | 验收标准交给 `official-doc-review` |
| “入口层可以替代主 Skill” | 入口层只负责调度，不负责正文细化 |
| “入口层已经知道下一步了，就顺手把正文写了” | 入口层只做状态判断，实际生成必须交给下一个 Skill |
| “我已经读过 core 规则，所以可以直接写正文” | 必须先单独调用 `official-doc-core`，再进入目标 Skill |
