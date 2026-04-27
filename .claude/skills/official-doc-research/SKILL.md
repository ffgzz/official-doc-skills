---
name: official-doc-research
description: 正式项目公文流程中的内部调研门禁，只能在 using-official-docs 已经解析 brief、初始化工作区并完成 official-doc-core 校验后，由 using-official-docs 调用；或在 official-doc-review / official-doc-revise 明确要求补调研时使用。不要把本 skill 作为用户正式公文请求的首个入口；用户一开始要求“深度调研、先搜资料、生成可研/立项/建议书”时，应先触发 using-official-docs。本 skill 负责澄清调研边界、建立调研矩阵、检查 MCP、执行多轮检索并沉淀来源、证据、摘记与事实台账。
allowed-tools: Read Write Edit Bash mcp__miro-google-search__google_search mcp__miro-google-search__scrape_website mcp__miro-reading__convert_to_markdown mcp__miro-python__create_sandbox mcp__miro-python__run_python_code mcp__miro-python__run_command
---

# official-doc-research

## 定位

这是“正式项目公文写作”的独立调研门禁 skill。

它的职责不是写正文，而是先把“能不能写、该怎么写、依据够不够新”这几件事做扎实。

本 skill 不是首个入口。若当前是用户刚发起的正式公文生成、重跑、续写或深度调研请求，而 `using-official-docs` 尚未加载并完成初始化，必须停止本 skill，切回 `using-official-docs`。

只有在以下条件之一成立时，本 skill 才能继续执行：
- `using-official-docs` 已经完成 brief 解析、工作区初始化、文档级编号方案和章节计划，并明确进入调研门禁。
- `official-doc-review` 或 `official-doc-revise` 已经给出明确问题，要求回到本 skill 补调研、补证据卡或补事实台账。

调研策略细则见：
- [references/research-depth.md](./references/research-depth.md)

<HARD-GATE>
在完成调研理解摘要、调研矩阵、MCP 可用性检查和最低检索轮次之前，禁止：
- 起草任何正文
- 把搜索结果直接改写成章节内容
- 调用五个章节写作 skill
- 声称“调研完成”

若本 skill 被作为用户正式公文请求的首个 skill 触发，禁止继续检索；应返回 `using-official-docs` 先做主入口初始化。
</HARD-GATE>

它服务于以下五类共性章节：
- 项目背景
- 研究内容
- 创新点
- 主要技术成果
- 主要技术指标

如果这些章节还没有经过本 skill 的调研门禁，就不应直接开始写正文。

## 何时必须使用

在前置条件已经满足后，以下任一情况出现时，必须用本 skill：
- 新项目已由 `using-official-docs` 完成 brief 解析和工作区初始化，准备进入五类共性章节写作
- 现有 `research-sources.md` 只有零散 2 到 3 条来源
- 现有来源大多超过 3 年，缺少近年信息
- 现有来源只有标题堆砌，没有提炼成可写正文的研究摘记
- 当前章节 skill 发现缺少可支撑断言的最新资料
- review 指出“调研过浅 / 来源过旧 / 来源分级不足 / facts-ledger 缺少主源”

## 前置条件

默认假定：
- `using-official-docs` 已完成工作区初始化
- `official-doc-core` 已完成公共校验

本 skill 不负责：
- 直接起草章节正文
- 直接进入 review / revise / assemble

## 必读文件

开始调研前，至少读取：
- `workspace/plan/<project-slug>/project-brief.md`
- `workspace/plan/<project-slug>/project-overview.md`
- `workspace/plan/<project-slug>/stage-gates.md`
- `workspace/outputs/<project-slug>/00-section-plan.md`
- `workspace/plan/<project-slug>/research-plan.md`
- `workspace/plan/<project-slug>/research-sources.md`
- `workspace/plan/<project-slug>/research-evidence.md`
- `workspace/plan/<project-slug>/research-notes.md`
- `workspace/plan/<project-slug>/facts-ledger.md`
- `workspace/plan/<project-slug>/progress.md`

## 调研前边界澄清

参考 `research-writing-skill/skills/brainstorming-research` 的做法，本 skill 不能把用户 brief 当成搜索关键词直接开搜。

开始检索前，必须在 `research-plan.md` 中先写入“调研理解摘要”，包括：
- 文体类型
- 项目主题
- 技术对象
- 应用场景
- 用户明确要求的章节
- 本轮必须激活的调研组
- 仍不确定但不影响启动调研的边界

如果 brief 已经足够明确，直接写入理解摘要，不要打断用户。

如果 brief 缺少关键边界，最多问用户一个问题。一次只问一个问题，不要一次性列出表单。

可以问的问题示例：
- `这份材料最终按可研报告还是立项申请书口径写？`
- `项目更偏船舶电气设计工具，还是更偏AI平台建设？`
- `是否有指定项目周期、牵头单位或硬性指标？`

只有用户回答后，才继续进入调研矩阵。

## 推荐 MCP 绑定

本 skill 默认按以下 MCP 工具组合执行联网调研：

### 1. `miro-google-search`
用途：
- 搜索网页来源
- 抓取网页正文
- 作为默认主检索工具

要求：
- 由 `miroflow_tools.mcp_servers.searching_google_mcp_server` 启动
- 需要 `SERPER_API_KEY`
- 需要 `JINA_API_KEY`

在实际调研中优先使用：
- `google_search(...)`：做检索
- `scrape_website(url)`：抓取网页正文

### 2. `miro-reading`
用途：
- 读取在线 PDF / DOCX / PPTX / XLSX / CSV
- 读取本地下载后的材料
- 把文档转成可提炼的 Markdown

要求：
- 由 `miroflow_tools.mcp_servers.reading_mcp_server` 启动
- 不需要额外 API key

在实际调研中优先使用：
- `convert_to_markdown(uri)`

### 3. `miro-python`（可选）
用途：
- 对抓取结果做清洗、对比、去重、结构化整理
- 在需要批量摘记、指标对比、简单统计时使用

要求：
- 由 `miroflow_tools.mcp_servers.python_mcp_server` 启动
- 需要 `E2B_API_KEY`

在实际调研中优先使用：
- `create_sandbox(...)`
- `run_python_code(...)`
- `run_command(...)`

## MCP 可用性预检

开始调研前必须确认当前 session 至少具备：
- `mcp__miro-google-search__google_search`
- `mcp__miro-google-search__scrape_website`

若涉及 PDF / DOCX / PPTX / XLSX / CSV，必须确认具备：
- `mcp__miro-reading__convert_to_markdown`

若需要批量去重、指标比对或结构化整理，优先确认具备：
- `mcp__miro-python__create_sandbox`
- `mcp__miro-python__run_python_code`
- `mcp__miro-python__run_command`

如果 `miro-google-search` 不可用，应停止联网调研并写入阻断原因。
不得回退到：
- 内置 `WebSearch`
- `WebFetch`
- DuckDuckGo
- Exa

如果 `miro-reading` 或 `miro-python` 不可用，可继续网页调研，但必须在 `research-plan.md` 中记录对应能力缺失，并降低对 PDF/批量整理的依赖。

## 工具规则

联网搜索只能使用当前 session 暴露的本地 `miro-*` MCP 工具。

默认优先级：
1. 当前 session 已暴露的 `miro-google-search`
2. 当前 session 已暴露的 `miro-reading` 用于读取在线或本地文档
3. 当前 session 已暴露的 `miro-python` 用于辅助整理与核验

不允许使用内置 `Web Search`。
不允许使用 DuckDuckGo、Exa、WebFetch 作为替代搜索通道。

如果当前没有可用的 `miro-google-search`，或本地 MCP 搜索持续报错：
- 停止联网调研
- 在 `research-plan.md`、`facts-ledger.md`、`progress.md` 中记录阻断原因
- 不得偷偷改用内置搜索继续推进

## 调研硬门槛

### 1. 不得只搜两三次就停

每个激活的调研组，默认至少完成 4 轮检索：
1. `范围确认`：确认主题边界、关键词、同义表述
2. `主源查证`：优先补政策、标准、船级社、企业官方、论文原文
3. `技术深挖`：围绕技术路线、同类项目、工程案例、指标口径做纵深检索
4. `交叉核验`：补主源、补最新资料、补相互印证

如果总检索量还停留在“2 到 3 次零散搜索”，默认视为调研未完成，不得放行正文。

对 `BG` 和 `TI` 这类高风险组，必须追加第 5 轮 `近年更新检索`，专门检索当前年份和上一年度资料。

### 2. 默认只看近 3 年

默认时间窗口是“当前年份及前 2 年”。

以当前 2026 年为例，优先使用：
- 2026
- 2025
- 2024

以下情况才允许引用更早来源：
- 国家标准、国际标准、船级社规范、经典论文
- 行业基础概念、长期沿用的底层定义
- 某项技术路线的里程碑原始文献

若来源早于近 3 年，必须在台账中注明：
- `历史基线`
- 或 `基础规范`

不得把 3 到 4 年前的旧新闻、旧宣传稿、旧资讯稿，当成当前现状依据。

### 3. 每个调研组必须达到最低保留量

每个激活调研组，在进入正文写作前，默认至少保留：
- 8 条有效来源
- 其中至少 5 条在近 3 年内
- 至少 2 条 `A主源`
- 至少 3 条 `B辅源`

如果是高风险组，最低要求如下：
- `BG` 背景/现状/政策趋势：不少于 12 条有效来源
- `TI` 技术指标/验收口径：不少于 10 条有效来源
- `IN` 创新点比较基线：不少于 8 条有效来源，且必须包含外部方案或技术路线对比

不得把全文来源总数、其他调研组来源数或事实条数加到某一组来源数中。`research-sources.md` 的状态栏必须按各组实际来源逐行统计；若 `BG` 只有 5 条来源，就只能写 `BG组5条，未达标`，不得写 `BG组已达12条`。未达标组不得在 `progress.md`、`stage-gates.md` 或终端中标记为“调研门禁完成”。

正式可研、立项申请书、项目建议书默认按上述门槛执行。只有用户明确要求“快速初稿/低调研版”，才允许降级为“调研不足的阶段稿”，并必须在 `progress.md` 和 `facts-ledger.md` 中记录风险，不能声称“可正式交付”。

### 4. 来源不能只停留在列表

调研完成不等于“记了几个链接”。

必须同时补齐：
- `research-plan.md`：调研组、轮次、查询式、覆盖状态
- `research-sources.md`：来源清单与分级
- `research-evidence.md`：每条来源的搜索命中、抓取/转换内容、证据点、短摘录和使用边界
- `research-notes.md`：逐条提炼的核心发现
- `facts-ledger.md`：能入正文的事实和核验状态

## 调研分组方法

不要按“整章”粗暴检索。
应按用户实际要写的内容拆成若干调研组。

常见调研组包括：
- `BG`：背景、现状、趋势、痛点、必要性
- `RC`：研究内容、技术路线、任务拆分、子课题命名
- `IN`：创新点对比基线、竞品路线、差异化表达
- `TA`：成果形态、交付件、验收件、知识产权口径
- `TI`：技术指标、行业基准、验收口径、合理区间

如果用户只要求其中一部分，只激活对应调研组，不要无谓扩大范围。

## 调研矩阵

建立 `research-plan.md` 时，必须先生成调研矩阵。

每个激活调研组至少拆出 3 个调研问题，每个问题至少包含：
- 问题编号
- 对应章节
- 需要回答的核心问题
- 初始查询式
- 预期来源类型
- 最低保留来源数
- 当前状态

示例：

```markdown
| 问题编号 | 调研组 | 对应章节 | 核心问题 | 初始查询式 | 预期来源类型 | 最低来源数 | 状态 |
|---|---|---|---|---|---|---|---|
| BG-Q1 | BG | 某背景章节 | 近年船舶电气设计智能化政策和行业背景是什么 | 船舶 电气设计 智能化 政策 2024 2025 2026 | 政策/行业报告 | 4 | 待检索 |
```

没有调研矩阵，不得开始正式检索。

## 查询式设计

每个调研组至少准备 4 类查询式，不要只换几个词重复搜索：

### A. 政策 / 官方口径
- 国家战略
- 部委政策
- 标准 / 规范 / 船级社要求
- 官方指南 / 官方公告

### B. 行业 / 企业实践
- 行业协会
- 头部企业
- 工程案例
- 解决方案白皮书

### C. 学术 / 技术路线
- 论文
- 研究机构报告
- 公开技术文档
- 关键方法综述

### D. 验收 / 指标 / 对标
- 常见指标口径
- 同类项目成果
- 性能区间
- 评测或验证方法

## 子代理并行检索（Claude Code 硬约束）

在 Claude Code 这类支持子代理的环境中，只要本轮属于正常项目调研，research 子代理不是可选项，而是默认执行方式。

以下任一情况出现时，主控必须按调研组派发 research 子代理：
- 激活调研组达到 2 组及以上
- 本轮为整稿调研或章节批量重跑前的补调研
- 本轮需要同时支撑多个正文章节

只有在以下特殊情况时，主控才可以不派发 research 子代理：
- 当前只补单个调研组的极小缺口
- 用户明确要求不要使用子代理
- 运行环境明确不支持子代理

即使发生豁免，主控也必须在 `progress.md` 写明：未派发原因、涉及哪一组、为什么不会影响调研门禁判定。不得泛泛写成“主控直接调研，合理”。

硬性分工：
- 子代理 A：`BG`（政策、现状、趋势）
- 子代理 B：`RC`（研究内容、技术路线）
- 子代理 C：`IN`（创新比较基线）
- 子代理 D：`TA`（成果形态与交付口径）
- 子代理 E：`TI`（指标区间与验收口径）

并行时必须执行“文件独占”：
- 每个子代理优先写入 `workspace/plan/<project-slug>/research-drafts/<group>/sources.md`
- 每个子代理优先写入 `workspace/plan/<project-slug>/research-drafts/<group>/evidence.md`
- 每个子代理优先写入 `workspace/plan/<project-slug>/research-drafts/<group>/notes.md`
- 若运行环境历史上已采用扁平命名，也可写入 `workspace/plan/<project-slug>/research-drafts/<group>-sources.md`、`<group>-evidence.md`、`<group>-notes.md`，但主控代理必须在合并前统一规范
- 主控代理统一合并进 `research-sources.md / research-evidence.md / research-notes.md / facts-ledger.md`

子代理不得直接宣布“调研门禁通过”，只能提交：
- 本组来源清单
- 证据卡草稿
- 可入正文与不可入正文的边界建议

子代理任务单应复用 `.claude/skills/official-doc-core/references/subagent-task-card-template.md`，并在“禁止项”中明确不得自行放行调研门禁。
主控在真正派发每个 research 子代理前，必须把“实例化后的完整任务单”写入 `workspace/plan/<project-slug>/agent-prompts/<task-id>.md`，不得只在 UI 中临时显示。
research 任务单文件名应使用 `research-<group>.md`，例如 `research-BG.md`、`research-RC.md`。若调研完成后 `agent-prompts/` 中仍看不到这些文件，默认视为 research 子代理未真正派发。
主控加载 `official-doc-research` 后，正常项目调研中下一步就应立即进入“按组派发 research 子代理”；不得由主控读取本 skill 后继续自己完成全部分组检索。
若 `agent-prompts/` 下没有任何 `research-*` 或分组任务单文件，而 `progress.md` 却写“调研已完成”，应视为流程错误。

主控代理必须在合并后统一复核：
- 来源数量门槛
- `A主源/B辅源` 比例
- 近 3 年占比
- 证据卡完整性

若本轮属于正常项目调研，而 `progress.md` 中出现以下任一表述，视为流程错误，应直接回退：
- `本轮主控直接调研，无需 research 子代理`
- `research 阶段未派发子代理，视为合理`
- `research-drafts 未生成，因为主控已直接完成`

`progress.md` 中的 research 子代理留痕也必须写成任务级独立条目，例如：
- `research-BG`
  - `任务编号：...`
  - `独占草稿目录：workspace/plan/<project-slug>/research-drafts/BG/`
  - `保留来源数：...`
  - `证据卡状态：...`
  - `是否已合并回canonical总账：是 / 否`

若 `progress.md` 中只有“调研完成”“调用 official-doc-research”之类总括表述，而没有 research 子代理任务条目，不能视为 research 子代理已经真正执行。

`research-drafts/` 只是分组草稿区，不是后续写作和 review 的正式依据。
如果只有 `research-drafts/*/evidence.md`、`research-drafts/*/notes.md`，但总账 `research-evidence.md`、`research-notes.md` 没有合并完成，则视为“调研门禁未完成”，不得放行章节写作、review 或 assemble。

`research-mapping.md`、检索执行概况、来源分组映射和搜索策略说明若需要保留，只能写入 `workspace/plan/<project-slug>/`。这些文件不得进入 `workspace/outputs/<project-slug>/`，也不得作为正式正文装配来源。

## 调研流程

### 第一步：建立调研计划

在 `research-plan.md` 中登记：
- 调研理解摘要
- 调研矩阵
- 激活的调研组
- 每组要回答的问题
- 每组默认时间窗口
- 每组最低来源数和分级要求
- 每组当前状态

### 第二步：分轮检索并留痕

每做一轮检索，都要在 `research-plan.md` 中追加：
- 轮次
- 调研组
- 查询式
- 时间过滤条件
- 检索工具：记录使用的是 `miro-google-search`、`miro-reading` 或 `miro-python` 中的哪一个
- 检索目标
- 结果概览
- 下一步

不要只记录“搜过了”或“找到一些资料”。
必须留下可复查的查询式、年份过滤和结果判断。

### 第三步：筛来源

把保留下来的来源登记到 `research-sources.md`，并补齐：
- 来源编号
- 调研组
- 轮次
- 查询式
- 使用工具
- 来源等级
- 发布时间
- 时效标记：`近3年` / `历史基线`
- 支撑章节 / 小节
- 是否可直接支撑正文断言

### 第四步：建立完整调研证据档案

每条进入 `research-sources.md` 的有效来源，必须在 `research-evidence.md` 中建立同编号证据卡。不得只写标题、链接或一句摘要。

每张证据卡至少记录：
- 来源编号、调研组、对应问题编号
- 来源标题、链接或定位、发布机构、发布时间、来源等级、时效标记
- 使用工具：`google_search` / `scrape_website` / `convert_to_markdown` / `miro-python`
- 检索查询式、命中标题、命中摘要、选择该来源的原因
- 抓取或转换状态：成功 / 部分成功 / 失败
- 正文可读性：完整 / 部分 / 仅摘要 / 需人工复核
- 抓取内容的结构化记录：主题范围、主要章节、关键数据、关键政策/标准/技术机制、与本项目相关内容、不宜使用内容
- 可用证据点表：证据点编号、可支撑断言、原文位置/页码/章节、证据强度、使用边界
- 必要短摘录：只保存必要短摘录，避免把长篇网页原文或受版权保护材料整段粘贴到文件
- 后续使用建议：可进入哪些章节、哪些事实可升入 `facts-ledger.md`、哪些只能作趋势参考、仍需补证什么

若 `scrape_website` 或 `convert_to_markdown` 抓取失败，仍须建立证据卡，记录失败原因、可见的搜索摘要、是否需要换源或人工补证。抓取失败来源不得直接支撑 `已核验` 事实。

对于政府公告、标准目录、官方产品页、论文摘要等可公开转述内容，应记录尽可能完整的结构化证据；对于长篇报告、论文、新闻稿或商业报告，不要复制全文，改为保存完整调研摘要、关键短摘录、页码/章节定位和可支撑断言。

### 第五步：做研究摘记

每条保留来源至少提炼一条“可用于写作”的摘记，写入 `research-notes.md`。

每条摘记必须包含：
- 来源编号
- 核心发现
- 支撑哪一章 / 哪一小节
- 可支撑的断言强度
- 风险提示

如果来源只停留在标题层，没有进入 `research-evidence.md` 并被提炼成摘记，等于尚未完成调研转写。

每个调研组结束时，还必须写 300 至 600 字的“调研结论摘要”，说明：
- 当前可形成的稳健判断
- 主要技术路线或政策趋势
- 与本项目相关的差距
- 可以进入正文的口径
- 暂不能强写的内容

### 第六步：升格为事实台账

只有当某条信息完成核验后，才可写入 `facts-ledger.md`，并标注：
- `已核验`
- `待核验`
- `仅作趋势参考`

## 联网执行顺序

每个调研组默认按以下顺序执行：

1. 先写调研理解摘要和调研矩阵
2. 再用 `miro-google-search.google_search(...)` 做首轮范围确认
3. 对进入候选集的网页，用 `miro-google-search.scrape_website(url)` 抓正文
4. 如果命中的是 PDF / DOCX / PPTX / XLSX / CSV 等材料：
   - 直接用 `miro-reading.convert_to_markdown(uri)` 转 Markdown
   - 或先下载到本地再用 `file:///...` 形式读取
5. 立即把每条保留来源写入 `research-evidence.md`，建立证据卡；证据卡未写入前，不得把该来源视为已完成调研
6. 如果要做去重、表格整理、指标比对、批量摘要：
   - 用 `miro-python` 进入沙箱处理
7. 每个调研组形成调研结论摘要
8. 只有进入 `research-evidence.md`、`research-notes.md` 和 `facts-ledger.md` 的内容，才允许被后续章节 skill 使用

## 与五个章节 skill 的关系

本 skill 负责“先把资料搜深、筛新、落账”。

五个章节 skill 负责：
- 读取本 skill 产出的调研台账
- 优先读取 `research-evidence.md` 中的来源证据卡，再读取摘要和事实台账
- 按各自规则写成正式公文表述

五个章节 skill 不应从零开始各搜各的。
如果写作时发现某个子问题仍缺最新资料，应先回到本 skill 补调研，再继续写。

## 完成判定

只有同时满足以下条件，才算本轮调研完成：
- `stage-gates.md` 中 G1、G2 已勾选
- 已写入调研理解摘要
- 已建立调研矩阵
- 已为激活调研组建立 `research-plan.md`
- 每个激活调研组至少完成 4 轮检索，高风险组完成追加近年检索
- 每个激活调研组达到最低来源保留量
- 近 3 年来源占主导，旧来源只作为基线或规范
- `research-evidence.md` 已为每条有效来源建立证据卡，且不只是链接列表
- `research-notes.md` 不再只是空表
- 若使用了 `research-drafts/` 并行草稿，主控代理已完成合并并把 canonical 总账写回 `research-sources.md / research-evidence.md / research-notes.md / facts-ledger.md`
- 每个调研组形成 300 至 600 字调研结论摘要
- `facts-ledger.md` 已沉淀出可入正文的事实
- `progress.md` 已明确记录“调研门禁完成”

若任一激活组来源数量或证据卡不达标，`progress.md` 必须写成“调研门禁未完成：XX组缺少N条来源/证据卡”，下一步只能回到本 skill 补调研，不能放行章节写作或装配。
若 `research-drafts/` 中已有分组证据卡，但 canonical `research-evidence.md` 缺失、为空或未合并到最新草稿，也必须写成“调研门禁未完成”，不得放行。

## 终端输出要求

终端里只简要汇报：
- 完成了哪些调研组
- 每组保留了多少条来源
- 是否已满足近 3 年和来源分级门槛
- 本轮使用了哪些 MCP 工具
- 下一步应交给哪个章节 skill

不要把大段网页原文或大段调研正文直接喷到终端。

