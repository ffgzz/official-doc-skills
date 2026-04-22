---
name: using-official-docs
description: 正式中文项目公文写作总入口。用于项目可行性报告、立项申请书、项目建议书、攻关任务书、技术总结等提示词驱动任务，尤其适用于这类输入：“请围绕某主题写一份正式项目可行性报告”“按以下章节顺序生成”“每章需要写什么、图表要求、字数要求”“切记深度调研”“请使用official-doc-writing-skill”。硬规则：本入口只负责解析 brief、初始化工作区、调用 official-doc-core 和 official-doc-research，自己绝不直接联网搜索或起草五类共性章节。
allowed-tools: Read Write Edit Bash
---

# using-official-docs

## 定位

这是新的主入口 skill。

它负责四件事：
- 解析用户给出的提示词 brief
- 初始化或复用工作区与 plan 台账
- 先调用 `official-doc-core`
- 先调用 `official-doc-research` 完成独立调研门禁
- 按“内容关键词”而不是“固定章名”路由到五个专项章节 skill
- 统筹后续 `table -> figure -> review -> revise -> assemble`

它不再负责：
- 读取外部模板目录
- 依赖材料包驱动流程
- 走旧的固定模板路由

## 核心原则

### 0.25 STOP 规则

如果 `using-official-docs` 已经加载，而你下一步想做的是：
- 搜背景
- 搜现状
- 搜技术路线
- 搜成果或指标口径

那说明顺序错了。

此时必须立即停止搜索，回到以下顺序：
1. 初始化 plan
2. 调用 `official-doc-core`
3. 调用 `official-doc-research`
4. 等 `official-doc-research` 完成后，再进入章节 skill

`using-official-docs` 自己绝不直接执行网络搜索。

### 0. 先初始化，后搜索

触发本 skill 后的第一步不是搜索。

正确顺序必须是：
1. 解析 brief
2. 初始化 workspace
3. 写入 plan 文件
4. 调用 `official-doc-core` 做公共校验
5. 调用 `official-doc-research` 做独立调研门禁
6. 路由专项 skill
7. 只有通过调研门禁后，专项 skill 才能开始写作

如果刚加载 `using-official-docs` 就直接开始搜索，这属于流程错误。

### 0.5 plan 文件归主入口写

以下文件的首次创建与首轮回填，归 `using-official-docs`：
- `project-overview.md`
- `project-brief.md`
- `stage-gates.md`
- `research-plan.md`
- `research-sources.md`
- `research-evidence.md`
- `research-notes.md`
- `facts-ledger.md`
- `progress.md`
- `source-materials.md`
- `workspace/outputs/<project-slug>/00-section-plan.md`

`official-doc-core` 只校验这些文件，不负责首次写入。

### 0.75 文档级编号方案由主入口确定

主入口必须在解析 brief 时确定全文编号方案，并写入：
- `workspace/plan/<project-slug>/project-brief.md`
- `workspace/outputs/<project-slug>/00-section-plan.md`

默认规则：
- 可研报告、立项申请书、项目建议书、技术总结：一级章 `一、`，二级节 `（一）`，三级项 `1.`，四级点 `（1）`。
- 项目指南、攻关任务书、任务清单型材料：一级任务 `1.`，二级要求 `（1）`，三级动作 `（a）`。
- 研究内容、主要攻关内容需要深度拆成课题/子课题时：章级编号仍服从全文方案，章节内部可采用 `课题1 / 子课题1.1 / 1.1.1`。

后续五个专项 skill 不得自行决定编号。若某章已经采用 `1.1` 技术分解，同级条目不得再改用 `（1）`；若全文二级标题采用 `（一）`，其他章节二级标题也必须沿用。

### 1. 路由依据是“写什么”，不是“这一章叫什么”

必须按用户 brief 中的以下信息综合判断：
- 章名
- 小节名
- 章节说明
- “本章需要写什么”
- 图表说明
- 字数说明

只要任一章节或小节命中专项内容关键词，就必须调用对应 skill。

不要因为章名写的是：
- `概述`
- `项目现状和发展趋势`
- `研发内容及技术关键`
- `预期目标`
- `研究结论`

就忽略专项 skill。

### 2. 五个专项 skill 是“规则库”，不是“固定章模板”

调用专项 skill 的目的，是套用其中对应小节的写法规则。

这意味着：
- 用户如果在第 1 章要求写 `行业背景` 和 `立项意义`，要调用 `official-doc-project-background`
- 用户如果在第 2 章要求写 `国内外现状` 和 `发展动向`，仍然调用 `official-doc-project-background`
- 用户如果在第 3 章要求写 `研究内容`、`子课题`、`关键技术`，调用 `official-doc-research-content`
- 用户如果在第 3 章标题是 `研发内容及技术关键`，且正文要求里还写了 `创新点`，那么同一章要同时调用 `official-doc-research-content` 和 `official-doc-innovation`
- 用户如果在第 7 章 `预期目标` 里要求写 `预期技术成果`，调用 `official-doc-technical-achievements`
- 用户如果同一章里还要求写 `技术指标`、`量化目标`、`预期成效`，还要调用 `official-doc-technical-indicators`

### 3. 一个章节可以命中多个专项 skill

不要强行“一章只对应一个 skill”。

允许的常见组合：
- `official-doc-project-background` + `official-doc-innovation`
- `official-doc-research-content` + `official-doc-innovation`
- `official-doc-technical-achievements` + `official-doc-technical-indicators`

### 4. 五个专项 skill 必须先过 `official-doc-research`

凡命中以下五类内容，必须先经过独立调研门禁，再进入正文写作：
- `workspace/plan/<project-slug>/research-sources.md`
- `workspace/plan/<project-slug>/research-evidence.md`
- `workspace/plan/<project-slug>/facts-ledger.md`
- `workspace/plan/<project-slug>/research-plan.md`
- `workspace/plan/<project-slug>/research-notes.md`

不得直接凭常识硬编：
- 项目背景
- 研究内容
- 创新点
- 主要技术成果
- 主要技术指标

`official-doc-research` 必须先做这些事：
- 按内容拆出激活调研组，而不是只按整章粗搜
- 默认只保留近 3 年资料；更早资料只能作为 `历史基线` 或 `基础规范`
- 每个激活调研组至少完成 4 轮检索；`BG`、`TI` 等高风险组还必须追加近年更新检索
- 每个激活调研组达到最低来源保留量后，才能放行正文写作

`research-sources.md` 至少记录：
- 来源标题
- 来源类型
- 来源等级：`A主源` / `B辅源` / `C参考`
- 发布机构 / 作者
- 发布时间
- 链接或定位信息
- 对应支持的章节 / 小节
- 是否可直接支撑正文断言：`可` / `不可`

`research-evidence.md` 至少记录：
- 每条有效来源的同编号证据卡
- 检索查询式、命中标题、命中摘要和选择原因
- 抓取/转换工具、抓取状态和正文可读性
- 来源内容的结构化记录、关键数据、政策/标准/技术机制
- 可支撑断言的证据点、原文位置/页码/章节和使用边界
- 必要短摘录；不要把长篇原文整段复制成全文转载

`facts-ledger.md` 至少记录：
- 事实表述
- 对应章节 / 小节
- 来源编号
- 主源编号
- 辅源编号
- 事实状态：`已核验` / `待核验` / `仅作趋势参考`
- 备注：是否允许写入正文

如果某条事实还没有完成登记，就不要先把它写进正文。

如果某个激活调研组只有 2 到 3 条来源，或大部分来源都超过 3 年，默认视为“调研未完成”，不得直接进入正文。
如果来源只写入 `research-sources.md`，但没有进入 `research-evidence.md` 建立证据卡，也视为“调研未完成”。

来源等级默认按以下口径处理：
- `A主源`：政府/主管部门/标准发布机构/船级社/论文原文/官方产品页/官方公告
- `B辅源`：主流行业媒体、研究机构报告、正规行业协会材料
- `C参考`：百科、博客、论坛、自媒体、聚合资讯、转载稿、问答社区

正文中的确定性事实默认需要：
- 至少 1 条 `A主源`
- 或 1 条 `A主源` + 1 条 `B辅源`

以下来源不得单独支撑 `已核验`：
- 百科
- 博客
- 论坛
- 自媒体
- 聚合资讯站
- 问答社区

这类来源最多只能作为 `C参考` 或辅助线索，不能单独把事实状态升为 `已核验`。

### 5. 专项章节必须“先过 research gate，再加载专项 skill，再写”

这是硬门禁，不是建议顺序。

只要某一章或某一小节命中以下任一专项类型：
- `official-doc-project-background`
- `official-doc-research-content`
- `official-doc-innovation`
- `official-doc-technical-achievements`
- `official-doc-technical-indicators`

主入口 skill 和 `official-doc-core` 都不得直接：
- 自己开始网络搜索该部分内容
- 自己起草该部分正文
- 自己先列该部分的资料提纲

正确顺序必须是：
1. `using-official-docs` 解析 brief
2. 调用 `official-doc-core`
3. 调用 `official-doc-research`
4. 判断命中的专项 skill
5. 立即加载对应专项 skill
6. 由该专项 skill 读取调研台账并负责该部分正文规则

如果已经识别出“背景类内容”，却没有先完成 `official-doc-research` 就开始搜索或起草背景资料，这属于流程错误。

专项 skill 写正文前，还必须先判断事实能否落正文：
- 已核验的事实：可进入正文
- 仅作趋势参考的事实：只能写成概括性判断，不写过细数字、文号、发布日期
- 待核验的事实：不得直接进入正文

若某条事实的来源只包含 `C参考`，即使内容看起来具体，也不得写成“已核验事实”。

专项 skill 写正文前，还必须先形成对应章节的“论证链”，至少覆盖：
- 本章核心判断
- 可用事实依据
- 差距或问题
- 技术机制或项目动作
- 输出成果、指标或验证方式
- 仍需保守处理的边界

如果论证链填不实，不得让专项 skill 靠空话扩写。应回到 `official-doc-research` 补调研，或只向用户提出一个会影响写作方向的关键问题。

### 5.5 搜索工具优先级

主入口不直接联网搜索。凡需联网调研，必须先进入 `official-doc-research`，并按它规定的本地 MCP 顺序执行：
1. `mcp__miro-google-search__google_search`
2. `mcp__miro-google-search__scrape_website`
3. `mcp__miro-reading__convert_to_markdown`
4. 必要时用 `mcp__miro-python__create_sandbox`、`mcp__miro-python__run_python_code`、`mcp__miro-python__run_command` 做整理核验

不允许使用内置 `Web Search` / `web search` 作为兜底。
如果当前会话没有可用的 `miro-google-search`，或 MCP 搜索报错无法完成，应：
- 停止该章节的联网搜索
- 在 `facts-ledger.md` 和 `progress.md` 中记录“搜索阻断：缺少可用 MCP 搜索”
- 不要偷偷改用内置搜索继续写作

### 6. 主入口是唯一统筹器

无论某个专项章节 skill 写完了什么，控制流都必须回到 `using-official-docs`。

由主入口继续判断并推进：
- 是否还有未写章节
- 是否要补表
- 是否要补图
- 是否要 review
- 是否要 revise
- 是否要 assemble

专项 skill 不能把“写完这一段正文”误当成“本轮任务完成”。

### 7. 文件优先，终端从简

正文、表格、图示、review、assembly 结果都应优先写入工作区文件。

终端里只保留：
- 当前执行到哪一步
- 写入了哪个文件
- 下一步要调用哪个 skill

不要把整章正文、整段大段落、整份长草稿直接输出到终端。

## 强制流程

### 新任务

1. 解析 brief，提取：
   - 项目主题
   - `project-slug`
   - 目标文体与全文编号方案
   - 章节顺序
   - 每章标题
   - 每章要求写的内容
   - 每章所需图表
   - 每章字数
   - 全文字数
2. 由主入口初始化或复用工作区：
   - 调用 `scripts/init_workspace.ps1`
   - 创建或复用 `workspace/plan/<project-slug>/`
   - 创建或复用 `workspace/outputs/<project-slug>/`
   - 创建或复用 `workspace/tables/<project-slug>/`
   - 创建或复用 `workspace/figures/<project-slug>/`
   - 创建或复用 `workspace/review/<project-slug>/`
   - 创建或复用 `workspace/assembled/<project-slug>/`
3. 由主入口初始化或更新 plan 台账：
   - `project-overview.md`
   - `project-brief.md`
   - `stage-gates.md`
   - `research-plan.md`
   - `research-sources.md`
   - `research-evidence.md`
   - `research-notes.md`
   - `facts-ledger.md`
   - `progress.md`
   - `workspace/outputs/<project-slug>/00-section-plan.md`
4. 单独调用一次 `official-doc-core`
5. 若命中五类共性章节，先调用一次 `official-doc-research`，建立调研计划、完成多轮检索并落账
6. 对每一章按关键词做路由判断
7. 命中五类共性章节时，先显式加载专项 skill，再由该 skill 读取调研台账并写作，并把正文写入 `workspace/outputs/<project-slug>/`
   - 专项 skill 必须服从 `00-section-plan.md` 中的编号方案，不得自行改用另一套标题编号
8. 未命中五类时，主入口按 brief 直接写该章，并把正文写入 `workspace/outputs/<project-slug>/`
9. 当所有章节正文完成后，主入口必须自动检查每章要求的表格和图示，并按需调用：
   - `official-doc-table`
   - `official-doc-figure`
10. 当请求的章节、表格、图示齐备后，主入口必须自动调用：
   - `official-doc-review`
11. 若 review 产出 Must Fix 或其他待修问题，主入口必须自动继续调用：
   - `official-doc-revise`
12. revise 完成后，主入口必须再次调用 `official-doc-review` 复核；只有 Must Fix 清零后，才允许继续推进
13. revise 后复核通过，主入口必须再次判断是否已满足装配条件；满足则继续调用：
   - `official-doc-assemble`
14. 装配后由 `official-doc-assemble` 触发 final review，主入口只在 final review 完成后才允许把本轮任务视为完成

只有在以下两种情况下才允许不继续推进：
- 用户明确只要求单点动作，例如只写某一章、只补某一张表、只做 review
- 被事实缺口阻断，且 `facts-ledger.md` 已明确记录缺口

### 继续推进

继续推进时必须先读取既有工作区，判断：
- 哪些章已完成
- 哪些专项 skill 已经调用过
- 哪些表图缺失
- 是否已 review
- 是否需要 revise
- 是否已具备 assemble 条件

不要重新按旧模板开新流程。

## 关键词路由矩阵

### A. `official-doc-project-background`

命中任一关键词就要调用：
- `项目背景`
- `背景`
- `行业背景`
- `建设背景`
- `宏观背景`
- `立项意义`
- `建设意义`
- `国内外现状`
- `国内现状`
- `国外现状`
- `发展现状`
- `现状分析`
- `行业发展动向`
- `发展趋势`
- `差距`
- `痛点`
- `问题分析`
- `攻关必要性`
- `建设必要性`
- `立项必要性`
- `产业链安全`
- `自主可控`

典型章名虽然不同，但都必须命中：
- `概述`
- `项目现状和发展趋势`
- `项目背景及必要性`
- `立项目的`

### B. `official-doc-research-content`

命中任一关键词就要调用：
- `研究内容`
- `研发内容`
- `主要研究内容`
- `主要攻关内容`
- `建设内容`
- `任务设置`
- `任务分解`
- `专题设置`
- `课题设置`
- `子课题`
- `子任务`
- `关键技术`
- `技术关键`
- `核心技术`
- `实施内容`
- `实施任务`

典型章名虽然不同，但都必须命中：
- `研发内容及技术关键`
- `项目建设方案`
- `项目任务设置`
- `技术路线和实施方案`

### C. `official-doc-innovation`

命中任一关键词就要调用：
- `创新点`
- `项目创新点`
- `技术创新`
- `主要创新`
- `创新性`
- `特色亮点`
- `创新突破`
- `差异化优势`

### D. `official-doc-technical-achievements`

命中任一关键词就要调用：
- `主要技术成果`
- `预期技术成果`
- `技术成果`
- `成果形式`
- `交付成果`
- `预期成果`
- `研究成果`
- `形成成果`
- `应用成果`

### E. `official-doc-technical-indicators`

命中任一关键词就要调用：
- `主要技术指标`
- `技术指标`
- `考核指标`
- `性能指标`
- `应用指标`
- `效能指标`
- `量化目标`
- `验收指标`
- `预期成效`
- `预期目标中的量化部分`

## 强制判定样例

### 样例 1

若用户写：
- 第 1 章 `概述`
- 需要写 `行业背景`、`立项意义`

则必须调用：
- `official-doc-project-background`

### 样例 2

若用户写：
- 第 2 章 `项目现状和发展趋势`
- 需要写 `国内外现状`、`行业发展动向`

则必须调用：
- `official-doc-project-background`

### 样例 3

若用户写：
- 第 3 章 `研发内容及技术关键`
- 需要写 `研究内容`、`子课题`、`关键技术`、`创新点`

则必须调用：
- `official-doc-research-content`
- `official-doc-innovation`

### 样例 4

若用户写：
- 第 7 章 `预期目标`
- 需要写 `预期技术成果`、`预期成效`

则必须调用：
- `official-doc-technical-achievements`
- `official-doc-technical-indicators`

### 样例 5

若用户写：
- 第 1 章 `概述`
- 小节包括 `行业背景`、`国内外现状`、`痛点问题`

则必须调用：
- `official-doc-project-background`

即使章名不是 `项目背景`，也不能漏调。

### 样例 6

若用户写：
- 第 4 章 `技术路线和实施方案`
- 其中要求先写 `任务设置`、`子任务分解`、`关键技术`

则必须调用：
- `official-doc-research-content`

即使章名看起来像实施方案，也要按内容命中。

### 样例 7

若用户写：
- 第 3 章 `关键技术及创新点`
- 第 7 章 `预期目标`
- 前者要求写 `差异化优势`
- 后者要求写 `预期技术成果`、`量化目标`

则必须调用：
- 第 3 章：`official-doc-innovation`
- 第 7 章：`official-doc-technical-achievements` + `official-doc-technical-indicators`

### 样例 8

若用户写：
- `请围绕船舶智能设计平台，写国内外现状、攻关必要性、三个研究专题、创新点、预期技术成果和主要技术指标`

即使用户没有明确写“第几章”，也必须按内容命中以下 skill：
- `official-doc-project-background`
- `official-doc-research-content`
- `official-doc-innovation`
- `official-doc-technical-achievements`
- `official-doc-technical-indicators`

## 章级执行规则

### 当章节命中专项 skill 时

主入口要做的是：
1. 把该章拆成若干写作需求点
2. 判断这些需求点激活了哪些调研组
3. 先调用 `official-doc-research`
4. 再判断每个需求点命中哪个专项 skill
5. 显式加载这些专项 skill
6. 由这些专项 skill 读取调研台账并执行正文规则，并将结果写入 `workspace/outputs/<project-slug>/` 对应章节文件
7. 主入口读取这些章节文件，继续推进后续表图与 review 流程
8. 再把结果拼回用户定义的章结构中

不要要求用户把章节名改成 skill 名。
不要在专项 skill 尚未加载前，主入口自己开始搜索该部分资料。
不要在专项 skill 内部兜底创建工作区或 plan 文件。

### 当章节没有命中专项 skill 时

由主入口直接按 brief 写。

常见直接写的章节包括：
- 技术路线
- 实施方案
- 工作基础
- 困难评估
- 进度安排
- 经费预算
- 研究结论

这些章节同样应写入 `workspace/outputs/<project-slug>/`，不要直接整章输出到终端。

## 禁止事项

- 不得要求用户提供旧式材料包才能启动流程
- 不得因为用户章名较泛就跳过专项 skill
- 不得把专项 skill 理解成“整章固定模板”
- 不得把 `预期技术成果` 误判成 `研究内容`
- 不得把 `预期成效`、`量化目标` 漏掉 `official-doc-technical-indicators`
- 不得在识别出专项章节后，由 `using-official-docs` 或 `official-doc-core` 直接跳过 `official-doc-research`
- 不得在未先通过 `official-doc-research` 的情况下直接搜索或起草背景、现状、痛点、必要性资料
- 不得在章节正文写完后就停住，不继续判断表图、review、revise、assemble
- 不得把长篇正文直接打印到终端替代写文件
- 不得把“已写出若干章节”误判为“已完成整份报告”

## 输出检查

完成调度前，至少自查一次：
- 是否已由主入口初始化工作区和 plan
- 是否已调用 `official-doc-core`
- 是否已先调用 `official-doc-research`
- 是否按小节内容而非章名做了路由
- 是否已在 `project-brief.md` 和 `00-section-plan.md` 中记录全文编号方案
- 各章同层级编号是否一致，是否避免了 `（1）` 与 `1.1` 在同层级混用
- 是否允许一章多 skill 叠加
- 五个专项内容是否都要求先过调研门禁再写
- 非专项章节是否仍由主入口负责统筹
- 是否已自动推进请求的表格和图示
- 是否已自动推进 `review -> revise -> assemble`
- 是否只在终端输出了简短状态，而把长正文写入文件

如果用户明明写了以下内容，但没有触发对应 skill，就说明路由失败：
- `国内外现状`、`攻关必要性` 没触发 `official-doc-project-background`
- `研究内容`、`子课题`、`关键技术` 没触发 `official-doc-research-content`
- `创新点`、`差异化优势` 没触发 `official-doc-innovation`
- `预期技术成果`、`交付成果` 没触发 `official-doc-technical-achievements`
- `技术指标`、`预期成效`、`量化目标` 没触发 `official-doc-technical-indicators`
