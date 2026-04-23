# 子代理任务单模板（Claude Code 并行）

> 适用范围：`official-doc-research`、五个正文 skill、`official-doc-review`、`official-doc-revise`、`official-doc-assemble` 的并行子任务。
>
> 目标：让子代理“可并行但不越权”，并保证与主流程同一套规则。

## 1. 任务单字段（必填）

```markdown
任务编号：
阶段：research / writing / review / revise / assemble-precheck
project-slug：
子代理角色：

【独占可编辑文件】(必填，禁止交叉改写)
- workspace/.../fileA.md
- workspace/.../fileB.md

【只读文件】(可选)
- workspace/.../fileX.md

【必须显式加载的 skill】(必填)
- official-doc-project-background
- official-doc-research-content

【必读规则文件】(至少 4 项，必填)
- workspace/plan/<project-slug>/project-brief.md
- workspace/outputs/<project-slug>/00-section-plan.md
- skills/official-doc-core/references/attachment-writing-patterns.md
- 对应专项 skill（例如 skills/official-doc-research-content/SKILL.md）

【本任务目标】(必填)
- 用 3 到 5 条写清“本子任务要完成什么”

【禁止项】(必填)
- 不得新增计划外二级节
- 不得改写全文编号方案
- 不得绕过调研门禁
- 不得在结论中宣称“可交付正式稿”
- 不得改动非授权文件
- 不得把“只读了 SKILL.md 文件”当成“已经调用了 skill”

【提交物】(必填)
- 已显式加载的 skill 清单与加载顺序
- 修改文件清单
- 未解决阻断项清单
- 需要主控代理仲裁的问题
```

## 2. 五个正文章节额外约束（必填）

若任务涉及以下章节，子代理必须先读取对应 skill：
- 背景与必要性：`official-doc-project-background`
- 研究内容与关键技术：`official-doc-research-content`
- 创新点：`official-doc-innovation`
- 技术成果：`official-doc-technical-achievements`
- 技术指标：`official-doc-technical-indicators`

若运行环境支持技能显式调用界面（如 Claude Code 的 skill 调用），子代理必须先显式加载上面列出的 skill，再开始读取台账、写作或回修。仅把对应 `SKILL.md` 文件放进“必读规则文件”，不算完成 skill 调用。

若同一任务同时命中多个 skill，任务单必须把 `【必须显式加载的 skill】` 按顺序写全。顺序不按固定章节号写死，而按当前任务实际包含的小节顺序、内容主次和 `00-section-plan.md` 的安排确定。

常见动态判定方式：
- 当前任务包含“背景 / 现状 / 发展动向 / 必要性”，加载 `official-doc-project-background`
- 当前任务包含“研究内容 / 子课题 / 关键技术 / 实施内容”，加载 `official-doc-research-content`
- 当前任务包含“创新点 / 差异化优势 / 特色亮点”，追加 `official-doc-innovation`
- 当前任务包含“技术成果 / 交付成果 / 成果形式”，加载 `official-doc-technical-achievements`
- 当前任务包含“技术指标 / 量化目标 / 预期成效 / 验收指标”，加载 `official-doc-technical-indicators`

若同一任务同时覆盖“研究内容 + 创新点”或“技术成果 + 技术指标/预期成效”，先加载当前任务中排在前面的主内容 skill，再加载后续补充 skill。

若任务单没有写清 skill 名称和顺序，子代理应视为任务单不合格并停止开工，而不是自行猜测。

且必须执行 `attachment-writing-patterns.md` 的硬门禁：
- 背景/研究/创新：覆盖 `对象 / 问题 / 动作 / 机制 / 输出 / 验证` 至少 4 项
- 成果/指标：覆盖各自要素至少 5 项

## 3. 子代理提交前自检（建议）

1. 标题与编号是否仍服从 `00-section-plan.md`
2. 是否新增了计划外二级节
3. 是否已显式加载任务单列出的全部 skill，且顺序正确
4. 是否出现口号化或重复扩写
5. 是否出现术语污染、公式残句
6. 是否需要补充来源或证据卡回写

## 4. 主控代理合并清单（建议）

1. 校验各子代理是否越权改文件
2. 校验子代理提交物中是否声明了“已显式加载的 skill 清单与顺序”；缺失则视为派发失败
3. 合并后执行风格检查和结构检查
4. 对冲突段落按“章节归属 skill”优先级仲裁
5. 统一输出唯一结论，不接受子代理各自给交付结论
