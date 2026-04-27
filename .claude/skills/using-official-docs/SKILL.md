---
name: using-official-docs
description: 正式中文项目公文写作的唯一首个入口和总调度器。凡用户要求生成、重跑、续写、检查或装配项目可行性报告、立项申请书、项目建议书、攻关任务书、技术总结等正式公文，都必须先使用本 skill；即使用户强调“深度调研”“先搜资料”“网络检索”，也仍然先用本入口解析 brief、初始化工作区和确定流程，不得把 official-doc-research 作为首个 skill。本入口负责调用 official-doc-core、official-doc-research、专项写作、review、revise、assemble，自己绝不直接联网搜索或起草五类共性章节。
allowed-tools: Read Write Edit Bash
---

# using-official-docs

## 定位

这是新的主入口 skill。

它负责这些事：
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

### 0.1 入口优先级

本 skill 是正式公文任务的唯一首个入口。

只要用户请求属于以下任一类型，必须先加载本 skill：
- 生成、重跑、续写、改写、装配正式中文项目公文
- 围绕某主题写可研报告、立项申请书、项目建议书、攻关任务书、技术总结
- 用户强调“深度调研”“先搜资料”“网络检索”“资料要够”
- 用户要求使用本公文写作 skill 体系

`official-doc-research` 是本入口调度的内部调研门禁，不是用户请求的首个入口。若一开始就命中 `official-doc-research`，应立即停止并切回本 skill，先完成 brief 解析、工作区初始化、文档级编号方案和章节计划。

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

### 0.3 先初始化，后搜索

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

### 0.8 章节计划是正式稿契约

`00-section-plan.md` 不是参考草稿，而是后续写作、回修和装配的结构契约。主入口必须把以下字段写清：
- `用户章节标记`：用户原始提示里的章次，如 `第一章`、`第七章`。
- `正式输出标题`：正式稿真实要输出的一级标题，如可研报告应写 `一、概述`，而不是 `第一章 概述`。
- `章节标题`：不含编号的标题名。
- `二级节清单` 或在备注中写清本章允许出现的二级节。

正式报告型材料的输出标题必须服从 `一、/二、/三、`。即使用户用“第一章、第二章”描述章节，也只能作为用户章节标记保存，不得直接输出为正式稿一级标题。若附件模板或用户明确要求 `第一章` 体例，才可改用该体例，并必须在全文编号方案中写明。

如果用户给出的章次跳号，例如只有第一、二、三、四、六、七章，主入口不得把“章节数量”写成 7 章；应写成“用户提供 6 个章节，原始标记跳过第五章，按用户顺序保留”。review 需要检查这种不连续是否来自用户 brief，而不是装配遗漏。

正文写作不得新增 `00-section-plan.md` 中没有登记的二级节。字数不足时，必须加深已登记小节的论证链、技术机制、表图说明和验证口径，不能追加 `技术创新与突破`、`应用前景`、`总结与展望` 等计划外小节来凑字数。

正文写作也不得用连续 `### 10.`、`### 11.`、`### 12.` 等流水号标题扩写。主入口、专项 skill 和 revise 都必须把扩写内容并入已登记二级节的自然段或少量必要三级标题中；普通章节不得出现 `远景展望`、`历史意义`、`社会责任`、`一带一路`、`人才培养` 等与 brief 无关的泛化标题。

### 0.9 Red Flags

出现以下想法或行为时，必须停止并回到 `00-section-plan.md`：
- “为了接近字数，我再加几个二级标题。”
- “用户写了第一章，所以正式稿也输出第一章。”
- “第四章普通章节可以用 11.1、13.2 继续下钻。”
- “review 只看字数和调研来源，标题结构差一点也可以过。”
- “style_check 的失败可以先解释掉，不必回修。”

### 0.95 Research / Writing 子代理硬约束（Claude Code）

在 Claude Code 这类支持子代理的环境中，`research` 与 `writing` 两个阶段不是“可选并行优化”，而是正常项目运行的默认执行方式。

只要命中以下任一条件，主入口就必须派发子代理，不能改成主控直接包办：
- 整稿生成
- 多章节生成
- 章节批量重跑
- 激活调研组 `>= 2`
- 章节数 `>= 3`
- 目标总字数 `>= 30,000`

主入口不得把整条流程完全外包给子代理。主入口必须保留以下职责：
- brief 解析与编号方案确定
- 章节计划与路由
- 回修合并与冲突仲裁
- 最终装配与是否可交付判定

硬性派发方式：
- 调研阶段：按 `BG / RC / IN / TA / TI` 分组派发；至少为所有激活组分别派发 research 子代理。
- 写作阶段：按章节文件派发；每个 writing 子代理独占一个 `workspace/outputs/<project-slug>/chXX-*.md`。

只有在以下特殊情况时，主入口才可以不派发对应子代理：
- 用户明确要求不要使用子代理
- 当前任务只是单章极小修补、单小节微调、单组补证
- 运行环境明确不支持子代理

即使出现上述豁免，主入口也必须在 `progress.md` 逐条写明：为何豁免、涉及哪一章或哪一组、为何不会影响流程合规。不得写成泛泛的“本轮主控直接完成，合理”。

子代理使用范围到此为止。进入 `review`、`revise`、`assemble` 后，主控代理不得再新派子代理，必须由主控直接完成复核、回修仲裁和正式装配。不要把“体量大”当成在后续阶段继续派发子代理的理由。

每个子代理任务单必须包含：
- `project-slug`
- `本章目标字数`（writing 必填）
- `【专项 skill 调用要求】`
- `【显式 skill 调用指令】`
- `【主控已预载专项 skill】`
- `【开工第一步】`
- `【本节证据清单】`（命中正文专项内容的写作任务必填）
- `【本节写作规则摘要】`（命中正文专项内容的写作任务必填）
- 独占可编辑文件清单
- 必读规则文件（至少包含 `project-brief.md`、`00-section-plan.md`、`attachment-writing-patterns.md`、对应专项 skill）
- 明确禁止项（不得新增计划外二级节，不得改编号方案，不得绕过调研门禁）
- 输出要求（只提交文件修改与问题清单，不直接宣称“可交付”）

任务单必须直接套用 `.claude/skills/official-doc-core/references/subagent-task-card-template.md` 的字段顺序，不得自由发挥成简版 prompt。
主控生成的实际 `agent-prompts/*.md` 必须尽量保留这些字段名原文，不得改写成 `## 任务标识`、`## 内容要求`、`## 禁止编造内容` 这类自由标题。若改写后导致 `【任务级留痕要求】`、`【提交物】`、`【主控已预载专项 skill】` 缺失，视为任务单无效。
尤其是写作子代理，`【专项 skill 调用要求】`、`【显式 skill 调用指令】`、`【主控已预载专项 skill】`、`【开工第一步】`、`【本节证据清单】`、`【本节写作规则摘要】` 六个区块必须出现在子代理可见 Prompt 的前部，不能藏在文件清单后面，也不能只留在主控代理自己的计划里。
此外，`【任务级留痕要求】` 与 `【提交物】` 两个区块也必须出现在实际任务单中；否则子代理没有被明确要求把 skill 执行结果回写给主控。

若运行环境支持 skill 显式调用（如 Claude Code），主入口派发命中五类正文专项内容的写作子代理时，必须把需要显式加载的 skill 写成精确 skill 名，并在 `【显式 skill 调用指令】` 中给出可直接执行的显式调用命令，优先使用 `/official-doc-project-background`、`/official-doc-research-content`、`/official-doc-innovation`、`/official-doc-technical-achievements`、`/official-doc-technical-indicators` 这类 slash 指令。子代理开工前必须真的执行这些显式调用。仅把对应 `SKILL.md` 路径列入“必读规则文件”不算完成调用。
若当前写作子代理负责的是非专项章节，主入口应在 `【专项 skill 调用要求】` 中明确写 `无，本任务不需要显式加载专项写作 skill`，而不是强行要求调用五个正文专项 skill。
若当前写作子代理负责的是非专项章节，`【显式 skill 调用指令】` 中必须明确写 `无，本任务不需要显式加载专项写作 skill`，不得伪造 slash 调用。

主入口自己也不能跳过这一层。凡命中五类正文专项内容的写作任务，主入口在派发子代理前必须先显式加载对应正文 skill，由主控先完成当前小节的规则提炼和证据抽取，再把任务派出去。不要把“首次加载正文 skill”的动作完全交给子代理。若主控本身未先加载对应正文 skill，就直接派发写作子代理，视为派发前置步骤不完整。
因此，命中正文专项内容的 writing 任务中，`【主控已预载专项 skill】` 不得写成 `否`、`无` 或“需要子代理自行加载”。只有主控已经先加载过对应专项 skill，才允许派发该任务。

若主入口在子代理 UI 的可见 Prompt 中看不到 `【专项 skill 调用要求】`、`【显式 skill 调用指令】`、`【主控已预载专项 skill】`、`【开工第一步】`，或命中正文专项内容时看不到 `【本节证据清单】`、`【本节写作规则摘要】`，应立即取消本次派发并按模板重发，不能假定子代理会自行补全。
若命中正文专项内容时看到 `【主控已预载专项 skill】` 为 `否`，也应立即取消本次派发并重发；这是主控前置步骤缺失，不是子代理自行弥补即可通过的问题。

若运行环境会在会话中显示 skill 调用事件（如 `Skill(...)`、`Successfully loaded skill`、slash 命令回显等），主控必须把“显式 skill 调用事件”作为子代理前 3 个可见动作之一进行核验。若前 3 个可见动作内没有出现要求的 skill 调用事件，主控必须立即中断本次派发并重发任务单，不得接受子代理随后用自然语言补一句“已加载”来替代真实调用。
若运行环境没有清晰显示 skill 调用事件，主控仍必须要求子代理先输出一次“起始回执”，至少包含：任务编号、任务单要求加载的专项 skill、显式调用指令原文、子代理实际显式加载的专项 skill、当前是否可以继续。没有这段起始回执，也不得接受后续正文结果。

主入口派发写作子代理后，还必须在 `workspace/plan/<project-slug>/progress.md` 留痕：
- 任务编号
- 独占文件
- 本章目标字数
- 专项 skill 调用要求
- 主控已预载专项 skill
- 本节证据清单摘要
- 本节写作规则摘要
- 子代理返回的专项 skill 执行声明

若缺少上述留痕，不得把该子代理结果判定为合格写作产物。

`progress.md` 中的写作子代理留痕必须写成任务级独立条目，例如：
- `writing-ch03-研发内容及技术关键`
  - `任务编号：...`
  - `独占文件：workspace/outputs/<project-slug>/ch03-...md`
  - `本章目标字数：...`
  - `任务单要求加载的专项 skill：...`
  - `主控已预载专项 skill：...`
  - `子代理实际显式加载的专项 skill：...`
  - `agent-skill-trace结论：匹配 / 本任务免加载`

若 `progress.md` 里只有“调用了某个正文 skill”“撰写了第几章”这类总括描述，而没有以上任务级条目，不能视为 writing 子代理已经真正执行。

主入口在真正派发任一 research / writing 子代理前，还必须把“本次实际下发的完整任务单”原样落盘到：
- `workspace/plan/<project-slug>/agent-prompts/<task-id>.md`

这里保存的是“实例化后的真实任务单”，不是模板路径。若只在 UI 中临时显示而不落盘，视为留痕不完整。

文件命名约定：
- research 子代理：`research-<group>.md`，例如 `research-BG.md`、`research-RC.md`
- writing 子代理：`writing-<chapter-file-stem>.md`，例如 `writing-ch03-研发内容及技术关键.md`

若正常项目调研或正常多章节写作结束后，`agent-prompts/` 下仍然没有上述命名文件，默认视为主控没有真正派发子代理。

除 `progress.md` 的摘要留痕外，主入口还必须创建并持续维护 `workspace/plan/<project-slug>/agent-skill-trace.md`，作为“子代理是否真的加载了对应正文 skill”的任务级核验台账。`progress.md` 只记录摘要，不作为最终核验依据；是否真正加载过 skill，以 `agent-skill-trace.md` 为准。

`agent-skill-trace.md` 的最低要求：
- 每个 writing 子代理任务各有 1 条独立记录，不得多任务共用 1 条记录
- 主控派发前先写入“预期记录”，子代理返回后再补全“实际执行记录”和“一致性结论”
- 记录字段至少包含：任务编号、阶段、子代理角色、独占文件、是否命中正文专项内容、任务单要求加载的专项 skill、显式 skill 调用指令、主控已预载专项 skill、子代理实际显式加载的专项 skill、显式调用指令原文、skill 调用事件原文、skill 加载确认原文、一致性结论
- 一致性结论只能使用 `匹配 / 不匹配 / 本任务免加载 / 缺失`
- 若当前任务为非专项章节，也必须留痕，并明确写 `本任务不需要显式加载专项写作 skill`
- 若命中正文专项内容，且 `主控已预载专项 skill` 为 `否`、`无` 或留空，一致性结论必须直接记为 `缺失`；不得寄希望于子代理单边补齐

主控在合并子代理结果前，必须先检查 `agent-skill-trace.md`：
- 若命中正文专项内容，而“任务单要求加载的专项 skill”和“子代理实际显式加载的专项 skill”不一致，一致性结论必须记为 `不匹配`
- 若 `【显式 skill 调用指令】` 已给出 slash 命令，但子代理没有返回对应命令的执行确认、`skill 调用事件原文` 或 UI 事件原文，一致性结论必须记为 `缺失`
- 若当前任务本应免加载正文专项 skill，则一致性结论只能是 `本任务免加载`
- 若子代理没有返回标准回执，或主控没有把回执落账，一致性结论必须记为 `缺失`

`agent-skill-trace.md` 中一致性结论不是 `匹配` 或 `本任务免加载` 的任务，不得并入正式写作成果；主控必须重派、重写或转入 revise，而不是带着不确定状态继续 assemble。

若本轮属于正常章节写作，而 `progress.md` 中出现以下任一表述，视为流程错误，应立即回退：
- `本轮主控直接写作，无需子代理留痕`
- `agent-skill-trace.md 留空（无需子代理留痕）`
- `写作未调用任何 writing 子代理，因此无需核验 skill`

同理，若本轮属于正常项目调研，而 `progress.md` 中出现以下任一表述，也视为流程错误：
- `本轮主控直接调研，无需 research 子代理`
- `research 阶段未派发子代理，视为合理`
- `research-drafts 未生成，因为主控已直接完成`

对子代理写正文时，主入口不得按固定章节号、固定文件名或某个项目当前结构写死 skill 映射。必须根据“当前被派发任务”动态判定：
- 以 `00-section-plan.md` 中该任务对应的章节标题、允许二级节、备注说明为主
- 以用户当前提示词中该任务要写的具体内容为准
- 以命中关键词和内容类型决定要加载哪些 skill

动态判定原则：
- 命中背景、现状、发展动向、痛点、必要性，加载 `official-doc-project-background`
- 命中研究内容、子课题、关键技术、实施内容，加载 `official-doc-research-content`
- 命中创新点、差异化优势、特色亮点，加载 `official-doc-innovation`
- 命中技术成果、成果形式、交付成果，加载 `official-doc-technical-achievements`
- 命中技术指标、量化目标、验收指标、预期成效，加载 `official-doc-technical-indicators`

若同一任务同时命中多个 skill，加载顺序必须按该任务内部的小节顺序和内容主次确定，而不是按固定章节号写死。

主入口在派发命中正文专项内容的写作子代理前，必须先显式加载对应正文 skill，再完成一次“本节证据抽取”和“本节规则提炼”，最后才能生成任务单。抽取来源只允许来自：
- `workspace/plan/<project-slug>/research-evidence.md`
- `workspace/plan/<project-slug>/research-notes.md`
- `workspace/plan/<project-slug>/facts-ledger.md`

抽取要求：
- 背景类二级节：至少整理 3 个证据点，覆盖政策/官方、行业场景、差距或影响三类中的至少三项。
- 研究内容、创新点、成果、指标：每个待写条目至少整理 2 个证据点，覆盖“问题/比较”与“机制/输出/验证”中的至少两类。
- 证据点必须写明“支撑什么判断”，不能只抄来源标题。

若当前小节抽不出足够证据点，主入口不得派发写作，应先回到 `official-doc-research` 补调研。不能把“证据不足”的任务直接扔给写作子代理，指望它边写边补。

规则提炼要求：
- 必须写清当前小节服从的标题层级和编号写法。
- 必须写清当前小节应优先套用的句式骨架。
- 必须写清当前小节不得出现的扩写方式，例如计划外二级节、连续流水号标题、空泛价值段。
- 规则摘要只能写当前任务真正需要执行的内容，不能把整份 skill 原文塞给子代理。

若主入口发现命中专项内容的子代理返回结果时没有声明“已显式加载的 skill 清单与顺序”，或实际执行痕迹显示未加载对应 skill，应视为该次派发无效，必须中断并按正确任务单重派，不能直接合并该结果。
若当前任务本就不命中专项内容，则只需检查该子代理是否明确声明“本任务不需要显式加载专项写作 skill”，不应把“没调专项 skill”误判成失败。

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
- 用户如果在某一章要求写 `行业背景` 和 `立项意义`，要调用 `official-doc-project-background`
- 用户如果在某一章要求写 `国内外现状` 和 `发展动向`，仍然调用 `official-doc-project-background`
- 用户如果在某一章要求写 `研究内容`、`子课题`、`关键技术`，调用 `official-doc-research-content`
- 用户如果某一章标题是 `研发内容及技术关键`，且正文要求里还写了 `创新点`，那么同一章要同时调用 `official-doc-research-content` 和 `official-doc-innovation`
- 用户如果在某一章 `预期目标` 小节里要求写 `预期技术成果`，调用 `official-doc-technical-achievements`
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
   - 每章正式输出标题
   - 每章要求写的内容
   - 每章允许出现的二级节清单
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
   - 创建或复用 `workspace/plan/<project-slug>/agent-prompts/`
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
   - `agent-skill-trace.md`
   - `workspace/outputs/<project-slug>/00-section-plan.md`
   - `00-section-plan.md` 的章节表必须包含 `用户章节标记 / 正式输出标题 / 章节标题 / 命中 skill / 编号层级要求 / 当前状态 / 备注`，备注中必须写清允许出现的二级节
4. 单独调用一次 `official-doc-core`
5. 若命中五类共性章节，先调用一次 `official-doc-research`，建立调研计划、完成多轮检索并落账
6. 对每一章按关键词做路由判断
6.5. 在 Claude Code 运行环境中，凡命中 `0.95` 的正常项目条件，必须仅在“调研组 / 正文章节”两个范围内派发子代理；每个子代理必须有独占写入范围
   - research 阶段必须按所有激活调研组派发子代理；不得由主控直接把多组检索合并完成后再宣称“调研完成”
   - 写作子代理的任务单必须直接使用 `subagent-task-card-template.md` 原字段；不能只保留“任务编号 / 文件清单 / 目标描述”的简版
   - 主入口在派发每个 research / writing 子代理前，必须先把实例化任务单写入 `workspace/plan/<project-slug>/agent-prompts/<task-id>.md`
   - writing 子代理任务单必须写明 `本章目标字数`；主控合并前必须核对当前章是否达到目标字数或合理区间，明显偏短时不得记为“已完成”
   - 命中正文专项内容的 writing 任务中，主入口必须先在主会话显式加载对应正文 skill，再生成任务单；若当前 `agent-prompts/*.md` 中出现 `【主控已预载专项 skill】：否`，说明流程错误
   - 命中正文专项内容的写作子代理，主入口必须先显式加载对应正文 skill，再整理当前小节的证据清单和规则摘要，分别写进 `【本节证据清单】` 与 `【本节写作规则摘要】`；证据不足时不得派发写作
   - 写作子代理的可见 Prompt 前部必须出现 `【专项 skill 调用要求】`、`【主控已预载专项 skill】`、`【开工第一步】`，以及（命中正文专项内容时）`【本节证据清单】`、`【本节写作规则摘要】`；若预览里看不到，主入口必须立即重发任务单
   - 写作子代理的实际任务单还必须包含 `【任务级留痕要求】` 与 `【提交物】`，明确要求子代理输出 `【专项 skill 留痕回执】` 供主控写入 `agent-skill-trace.md`
   - 写作子代理要不要加载专项 skill，必须按当前任务命中的内容类型动态判定，不能按固定章节号、固定文件名或当前项目结构写死
   - 在支持 skill 调用的环境中，命中专项内容的写作子代理必须先显式加载对应 skill，再开始读写文件；未命中专项内容的写作子代理应明确声明“本任务不需要显式加载专项写作 skill”
   - 主入口必须把派发要求、主控预载记录、证据清单摘要、规则摘要和子代理返回的 skill 加载确认回写 `progress.md`，并把标准回执原样写入 `agent-skill-trace.md`；两者缺任一项，该次写作不得计入“已完成”
   - 正常章节写作任务中，`agent-skill-trace.md` 不得为空；若为空，只能说明主入口没有真正派发 writing 子代理，应回退
   - 正常项目调研任务中，`agent-prompts/` 下必须存在 research 任务单文件，且 `research-drafts/` 下必须存在对应激活组的草稿；若两者都缺失，只能说明主入口没有真正派发 research 子代理，应回退
   - 若 research / writing 任一阶段应派子代理却没有落下 `agent-prompts/*.md`，主入口不得继续到 `review / revise / assemble`，必须先把流程状态写成失败并回到本 skill 重跑派发
   - `review`、`revise`、`assemble` 三个阶段禁止派发子代理；这些阶段只能由主控代理直接执行
7. 命中五类共性章节时，先显式加载专项 skill，再由该 skill 读取调研台账并写作，并把正文写入 `workspace/outputs/<project-slug>/`
   - 在 Claude Code 的正常多章节写作中，这里的“由该 skill ...写作”唯一允许的解释是：主控先显式加载对应正文 skill，由该 skill 的规则生成合格子代理任务单并派发 writing 子代理，由 writing 子代理实际完成该章正文落盘。主控不得把“我已经加载了 skill”当成自己直接写完整章的许可
   - 专项 skill 必须服从 `00-section-plan.md` 中的编号方案，不得自行改用另一套标题编号
   - 专项 skill 不得新增 `00-section-plan.md` 未登记的二级节；如需扩写，只能加深既有小节
   - 专项 skill 必须执行 `attachment-writing-patterns.md` 的硬门禁，关键段落至少覆盖对象、问题、动作、机制、输出、验证中的必要要素
   - 专项 skill 必须消费主入口提供的本节证据清单，把证据转化为正文中的事实、差距、机制、成果和验收口径；不得只读取台账却把正文写成空泛扩写
   - 若由子代理写作，该子代理也必须显式加载当前任务实际命中的专项 skill；“父代理已经加载过”不能替代子代理自己的 skill 调用
   - 若当前章节写出来仍明显违背对应专项 skill 的编号方案、句式门禁或论证链要求，应优先怀疑“子代理未按任务单调用专项 skill”，而不是直接把该散件当成合格初稿
8. 未命中五类时，主入口按 brief 路由该章，并把正文写入 `workspace/outputs/<project-slug>/`
   - 若本轮属于正常多章节写作，此处唯一允许的做法仍然是：主入口负责路由、生成任务单和最终合并，由 writing 子代理实际写章。主控不得以“非专项章节”作为自己直接写完整章的理由
   - 非专项章节同样必须服从正式输出标题和二级节清单，不得用 `第一章` 体例替代 `一、` 体例，不得用 `11.1` 等十进制标题下钻
   - 非专项章节若需要三级标题，必须写成 `1.`、`2.`、`3.`，不得写成 `1 `、`2 ` 这类无点号写法
   - 非专项章节若需要四级标题，必须在各自父级三级标题内重新从 `（1）` 起号，不得承接上一章或上一节累计成 `（25）`、`（30）`
   - 非专项章节同样不得用连续流水号标题或泛化展望标题堆篇幅；若字数不足，应补事实依据、实施条件、风险机制、验收口径和边界说明
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

15. 在进入 `official-doc-review` 之前，主入口必须先做一次流程前置核验：
   - 若本轮属于正常项目调研，`agent-prompts/` 中必须已有 research 任务单文件
   - 若本轮属于正常多章节写作，`agent-prompts/` 中必须已有 writing 任务单文件，且 `agent-skill-trace.md` 不得为空
   - 若本轮 revise 触及五类正文专项章节，`progress.md` 中必须已经写入 `本轮 revise 加载的正文 skill`
   - 缺任一项都不得进入 `official-doc-review`

只有在以下两种情况下才允许不继续推进：
- 用户明确只要求单点动作，例如只写某一章、只补某一张表、只做 review
- 被事实缺口阻断，且 `facts-ledger.md` 已明确记录缺口

## outputs / plan 目录边界

`workspace/outputs/<project-slug>/` 只允许存放章节正文散件和 `00-section-plan.md`。

以下内容属于内部过程材料，只能写入 `workspace/plan/<project-slug>/`，不得写入 `workspace/outputs/<project-slug>/`：
- `research-mapping.md`
- `检索与资料映射说明`
- 搜索执行概况
- 来源分组与章节映射
- 抓取日志、转换日志、搜索策略说明
- 任何不属于正式正文的调研过程说明

若主入口把上述文件写入 `workspace/outputs/<project-slug>/`，后续 `review / revise / assemble` 必须将其视为错误产物并清除，不得装入 formal-draft。

## 正文污染清理要求

正式正文、图示说明稿、formal-draft 中不得出现：
- `【来源：...】`
- `来源：原始资料`
- `BG-1-01`、`RC-1-01`、`IN-1-01`、`TA-...`、`TI-...`
- `检索与资料映射说明`

主入口在写作合并、revise 合并和 assemble 前都必须检查这些污染项。只要仍然存在，就不得判定为“可装配正式稿”或“可正式交付稿”。

## 字数硬门槛

若 brief、`project-brief.md` 或 `00-section-plan.md` 已给出全书总字数或章节字数，主入口必须把它们视为硬门槛，而不是“尽量接近”的建议值。

- 派发 writing 子代理时，任务单必须写明本章目标字数或合理区间
- 主控合并章节时，若当前章明显低于目标字数，应优先回到该章继续补深度，而不是直接进入 review / assemble
- revise 若因补字数扩写章节，也只能在既定章节和小节内补充事实依据、机制、输出、验收和边界，不能用计划外标题凑字数
- 若总字数未达标，不得把当前稿件写成“可装配正式稿”或“可正式交付稿”

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
- 某一章标题为 `概述`
- 需要写 `行业背景`、`立项意义`

则必须调用：
- `official-doc-project-background`

### 样例 2

若用户写：
- 某一章标题为 `项目现状和发展趋势`
- 需要写 `国内外现状`、`行业发展动向`

则必须调用：
- `official-doc-project-background`

### 样例 3

若用户写：
- 某一章标题为 `研发内容及技术关键`
- 需要写 `研究内容`、`子课题`、`关键技术`、`创新点`

则必须调用：
- `official-doc-research-content`
- `official-doc-innovation`

### 样例 4

若用户写：
- 某一章标题为 `预期目标`
- 需要写 `预期技术成果`、`预期成效`

则必须调用：
- `official-doc-technical-achievements`
- `official-doc-technical-indicators`

### 样例 5

若用户写：
- 某一章标题为 `概述`
- 小节包括 `行业背景`、`国内外现状`、`痛点问题`

则必须调用：
- `official-doc-project-background`

即使章名不是 `项目背景`，也不能漏调。

### 样例 6

若用户写：
- 某一章标题为 `技术路线和实施方案`
- 其中要求先写 `任务设置`、`子任务分解`、`关键技术`

则必须调用：
- `official-doc-research-content`

即使章名看起来像实施方案，也要按内容命中。

### 样例 7

若用户写：
- 某一章标题为 `关键技术及创新点`
- 另一章标题为 `预期目标`
- 前者要求写 `差异化优势`
- 后者要求写 `预期技术成果`、`量化目标`

则必须调用：
- 命中 `创新点 / 差异化优势` 的那一章：`official-doc-innovation`
- 命中 `预期技术成果 / 量化目标` 的那一章：`official-doc-technical-achievements` + `official-doc-technical-indicators`

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

