# CLAUDE.md

## 默认入口

- 当用户已经提供了较完整的长 prompt、章节要求、原始资料和输出约束时，默认先执行 `/using-official-docs`
- 当用户只有主题、文种、零散材料，或明确希望“先问我该输入什么、帮我把提示词整理出来”时，先执行 `/official-doc-prompt-builder`
- `/official-doc-prompt-builder` 只负责“前置问询 + prompt 组装 + 交接”，不直接调研、不直接写正文
- `/using-official-docs` 仍是正式写作主入口；凡进入调研、正文、表图、review、revise、assemble 流程，最终都必须回到 `/using-official-docs`

## 全局约束

- 当前工作方式是“主题 + 章节要求 + 表图要求 + 字数要求”的提示词驱动，不是“固定模板套写”
- 不得还没进入 `/using-official-docs` 或 `/official-doc-prompt-builder` 就直接联网搜索或直接起草正文
- 不得因为用户写了“先深度调研”就绕过技能体系，按默认搜索流程自由执行
- 用户如果口头提到“official-doc-writing-skill”，仍统一解释为进入 `/using-official-docs`，不要再走单独入口
- 用户如果口头提到“帮我整理 prompt”“给我一个问答式模板”“告诉我需要输入哪些信息”，统一解释为先进入 `/official-doc-prompt-builder`
- 所有回答使用中文

## 强制流程

1. `/using-official-docs` 解析 brief、初始化 `project-slug` 工作区、写 `00-section-plan.md`
2. `/official-doc-core` 单独执行一次，建立公共门禁
3. 若本轮任务属于正常项目调研（整稿生成、章节批量重跑、需要同时回答 2 组及以上调研问题、或需要为多个正文章节建立证据链），`research` 阶段必须派发调研子代理；不得由主控直接把 `BG / RC / IN / TA / TI` 多组检索全部写完后再声称“调研完成”
3. 只有五类共性章节调用专项正文 skill：
   - `/official-doc-project-background`
   - `/official-doc-research-content`
   - `/official-doc-innovation`
   - `/official-doc-technical-achievements`
   - `/official-doc-technical-indicators`
4. 其他章节直接按 brief 写作，不额外调用这五个专项正文 skill
5. 对上述五类共性章节，必须先完成调研、登记来源和证据，再开始写作
6. 只允许在 `research` 和 `writing` 阶段使用子代理；`review`、`revise`、`assemble` 必须由主控直接执行
7. 若本轮任务属于正常章节写作（整稿生成、多章节生成、章节批量重跑），`writing` 阶段必须派发 writing 子代理；不得由主控直接一口气写完全部章节后再把缺少子代理留痕解释为“无需派发”
7. 公共后续流程保持为：
   - `/official-doc-table`
   - `/official-doc-figure`
   - `/official-doc-review`
   - `/official-doc-revise`
   - `/official-doc-assemble`

## 技能结构

- 运行时生效目录是 `.claude/skills/`
- `official-doc-prompt-builder` 是前置 intake skill
- `using-official-docs` 是主 skill
- `official-doc-core` 提供公共门禁
- `official-doc-research` 是独立调研门禁
- 五个正文专项 skill 只在命中对应章节内容时调用
- 不再保留 `official-doc-writing-skill` 这层总入口 skill

## 写作阶段硬约束

- 进入 `writing` 阶段后，若本轮任务是“整稿生成、多章节生成、章节批量重跑”这类正常写作任务，主控默认必须派发 writing 子代理，按章节文件拆分执行；不得由主控直接一口气写完整批正文后再假定流程合格
- 在支持子代理的 Claude Code 环境中，“命中正文专项 skill”与“主控直接写完整章”不能同时成立；主控可以先加载 skill、提炼规则、生成任务单，但正常章节正文必须由 writing 子代理实际落盘
- writing 子代理按章节文件独占写入；一个子代理只负责一个 `workspace/outputs/<project-slug>/chXX-*.md`
- 主控在真正派发每个 writing 子代理前，必须把“本次实际下发的完整任务单”落盘到 `workspace/plan/<project-slug>/agent-prompts/<task-id>.md`；不得只在 UI 中临时显示而不留存
- 命中五类正文专项内容的写作子代理，必须先显式加载对应正文 skill，再开始读取台账和写作
- 非专项章节写作子代理不得伪造专项 skill 调用；任务单中必须明确写“本任务不需要显式加载专项写作 skill”
- 主控必须维护 `workspace/plan/<project-slug>/agent-skill-trace.md`，作为 writing 子代理是否真的加载了对应正文 skill 的任务级核验台账
- 每个 writing 子代理都必须在 `agent-skill-trace.md` 留下独立记录，不得多任务共用一条
- 命中五类正文专项内容的 writing 子代理，台账至少要记录：任务单要求加载的专项 skill、显式 skill 调用指令、子代理实际显式加载的专项 skill、显式调用指令原文、skill 调用事件原文、skill 加载确认原文、一致性结论
- 若运行环境显示 `Skill(...)`、`Successfully loaded skill`、slash 回显或等价事件，主控必须把该事件原文写入 `agent-skill-trace.md`；只在 `progress.md` 写“已加载”不算通过
- 非专项章节 writing 子代理也必须留痕，并明确写“本任务免加载专项写作 skill”
- 若 writing 子代理缺少 `agent-skill-trace.md` 记录、记录不完整、或一致性结论不是 `匹配 / 本任务免加载`，该子代理结果不得并入正式写作成果
- 正常章节写作任务中，不允许在 `progress.md` 写“本轮主控直接写作，无需子代理留痕”“agent-skill-trace.md 留空是合理的”这类豁免说明；这类表述只可用于单章极小修补、单小节微调或用户明确禁止子代理的特殊情况
- 只有当本轮任务确实不是正常章节写作，例如单个小节微调、单章极小修补、或用户明确要求不要派发子代理时，主控才可以不派 writing 子代理；此时必须在 `progress.md` 明确写明未派发原因
- 若本轮应属正常章节写作，却没有派发 writing 子代理，也没有在 `progress.md` 写明合理豁免原因，视为流程不完整
- 若 `agent-prompts/` 为空、`agent-skill-trace.md` 为空、或两者与章节完成状态不匹配，主控必须立刻停止，不得进入 `review / revise / assemble`，而应回到 `/using-official-docs` 重新按子代理流程派发

## 调研阶段硬约束

- 进入 `research` 阶段后，若本轮任务是整稿调研、章节批量重跑前的补调研、或激活调研组达到 2 组及以上，主控默认必须按调研组派发 research 子代理；不得由主控直接完成全部分组检索后再把“无子代理”解释为合理
- 在支持子代理的 Claude Code 环境中，正常项目调研若未形成 `research-*` 或分组任务单文件，即可视为 research 子代理未真正派发
- research 子代理按组独占写入 `workspace/plan/<project-slug>/research-drafts/<group>/`
- 主控在真正派发每个 research 子代理前，必须把“本次实际下发的完整任务单”落盘到 `workspace/plan/<project-slug>/agent-prompts/<task-id>.md`
- 正常项目调研任务中，不允许在 `progress.md` 写“本轮主控直接调研，无需 research 子代理”的兜底说明；若确因单组小补证不派发，也必须在 `progress.md` 明确写明只涉及哪一组、为什么可豁免
- 若本轮应属正常项目调研，却没有派发 research 子代理，也没有在 `progress.md` 写明合理豁免原因，视为调研流程不完整
- 若 research 任务单未落盘到 `agent-prompts/`，或 `research-drafts/` 根本没有对应组草稿，而 `progress.md` 却写“调研完成”，则这轮调研必须判为失败

## 正文与装配禁入项

- `formal-draft.md`、各章正文散件以及表图说明稿中，不得出现 `【来源：...】`、`来源：原始资料`、`BG-1-01`、`RC-1-01` 这类内部来源标记；证据可以被消费，不能裸露给正式成稿
- `research-mapping.md`、`检索与资料映射说明`、检索执行概况、来源分组映射、抓取日志、搜索策略说明等内部调研说明，只能放在 `workspace/plan/<project-slug>/`，不得写入 `workspace/outputs/<project-slug>/`，更不得进入 `formal-draft.md`
- 图示 `.mmd` 在宣布完成前，必须通过 Mermaid 语法校验；带 `Syntax error in text`、解析失败占位图或明显不闭合的 `subgraph/end` 结构的图，不得进入装配
- 用户给出总字数或章节字数要求时，必须把它当成硬门槛。主控在写作和回修阶段都不得擅自降低目标字数，也不得在未达标时把当前稿件写成“可交付正式稿”

## 回修补充

- 若 `revise` 触及五类正文专项章节，必须重新加载对应正文 skill 再修改
- 相关回修必须在 `workspace/plan/<project-slug>/progress.md` 留下“本轮 revise 加载的正文 skill”留痕
- 上一轮正文写作时加载过对应 skill，不构成当前 revise 的有效替代；revise 阶段必须重新加载
- 若 revise 修改了五类正文专项章节，却没有重新加载对应 skill，或没有在 `progress.md` 写明“本轮 revise 加载的正文 skill / 受影响文件或小节 / 证据摘要 / 规则摘要”，则该次 revise 不得视为完成
- 若 revise 修改或扩充了五类正文专项章节，还必须同步清除正文中的内部来源标记、检索说明残留和其他违反专项写法规则的污染内容；不得只补字数、不清理污染
- 若 `progress.md` 中没有出现一条以 `本轮 revise 加载的正文 skill` 开头的实际记录，则本轮 revise 默认视为未按专项规则执行，不得进入 final review
