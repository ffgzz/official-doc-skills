---
name: official-doc-revise
description: 用于在 official-doc-review 之后回修当前项目稿件。它根据问题清单定向修复章节、表格、图示、来源、风格和依赖问题，不得编造事实，并在完成后更新进度和装配判定。
allowed-tools: Read Write Edit Bash
---

# 公文回修 Skill

> 2026-04 架构更新：以下规则优先于全文旧内容。回修不再围绕旧模板章节，而是围绕当前 `project-slug` 的 review 结果。
>
> 当前回修重点：
>
> - 先修 Must Fix
> - 先补搜索和依赖关系，再修措辞
> - 先统一全文编号方案，再处理单章措辞
> - 浅层章节必须先重建论证链，再扩写正文
> - 项目建设方案、成果、指标必须改回附件式“针对问题 -> 研究/构建 -> 实现 -> 形成/验证”的正式写法
> - 正文必须改回正式公文自然段，不能保留答题卡式 AI 痕迹

## 适用时机

以下任一情况出现时，应主动使用本 Skill：

- `official-doc-review` 已经产出问题清单
- 用户要求“修改”“回修”“按复核意见调整”
- 你准备装配正式总稿，但当前草稿仍存在标题、口径、表图引用或格式问题

## 核心目标

依据 `workspace/review/<project-slug>/review.md` 的问题清单，定向修复正文、表格、图示和台账中的问题。
本 Skill 解决的是“把诊断结果落实到文件”，不是重新写一份新稿。

## 使用前必读

开始回修前，至少读取以下文件：

- `workspace/review/<project-slug>/review.md`
- `workspace/plan/<project-slug>/project-brief.md`
- `workspace/plan/<project-slug>/source-materials.md`
- `workspace/outputs/<project-slug>/00-section-plan.md`
- `workspace/plan/<project-slug>/research-sources.md`
- `workspace/plan/<project-slug>/research-evidence.md`
- `workspace/plan/<project-slug>/facts-ledger.md`
- 当前受影响的 `workspace/outputs/<project-slug>/`、`workspace/tables/<project-slug>/`、`workspace/figures/<project-slug>/` 文件
- `.claude/skills/official-doc-core/references/attachment-writing-patterns.md`

## 使用前必做

1. 读取对应 `workspace/review/<project-slug>/review.md`
2. 按严重级别区分 Must Fix / Should Fix
3. 逐项定位受影响文件
4. 核对 `workspace/plan/<project-slug>/source-materials.md` 中用户提示词给出的项目资料
5. 核对 `workspace/plan/<project-slug>/facts-ledger.md` 中相关事实口径
6. 若修复来源或补调研，核对并补齐 `workspace/plan/<project-slug>/research-evidence.md`

## 强制规则

- 优先修复 Must Fix，再处理 Should Fix
- 不得绕过 review 清单直接大改全文
- 不得为了“修完”而补造事实
- 无法确认的事实继续保留 `【待补】`
- 修订后要同步更新 `workspace/plan/progress.md`
- 若 Must Fix 包含高优先表图缺失，必须优先补表 / 补图，再回修正文引用
- 若 Must Fix 包含章节配比失衡，必须优先修正章节展开深度，再处理措辞润色
- 若 review 指出“正式稿中的信息比散件文件更空”或“已知事实被回退成 `【待补】`”，必须优先修复该回退问题，再做其他润色
- 若 review 指出“用户提示词项目资料未消费”或“提示词资料未证据化”，必须先回到 `source-materials.md`、`project-brief.md` 和 `facts-ledger.md` 抽取 USER 系列项目事实，再修正文；不得只补外部调研资料。
- 若 review 指出总字数或章节最低字数不达标，必须先读取 `project-brief.md` 和 `00-section-plan.md`，列出 `总字数缺口`、`逐章缺口`、`重点章节缺口`，再按章节轻重规则定向压缩或补足。不得只补一个总论段来冲总字数。
- 若 review 指出正文存在列表化、加粗小标签或机械过渡词，必须优先改回自然段表述，再进入装配
- 若 review 指出内容深度不足，不得只加套话或同义改写；必须先补齐“核心判断、事实依据、差距问题、技术机制、输出结果、边界条件”六项论证链，再重写对应段落
- 若 review 指出标题编号混乱，必须先按 `00-section-plan.md` 的全文编号方案统一标题层级；不得在回修时把同一层级继续混用 `（1）` 和 `1.1`
- 若 review 指出正式报告型稿件使用了 `# 第一章`、`# 第二章` 等标题，必须改为 `00-section-plan.md` 的正式输出标题，如 `# 一、概述`、`# 二、项目现状和发展趋势`
- 若 review 指出存在计划外二级节，不能继续保留并润色；必须删除该二级标题，或将其中确有必要的内容并入 `00-section-plan.md` 已登记的小节
- 若 review 指出普通章节使用 `#### 11.1`、`#### 13.2` 等十进制标题，必须改为当前层级方案下的 `#### （1）`、`#### （2）` 或自然段，不得让项目研发内容内部的任务编号污染其他章节
- 若 review 指出总字数或章节最低字数不达标，补写只能加深已登记章节和小节的事实依据、技术机制、输出成果、测试验证、应用边界，不得靠新增计划外章节或二级节凑字数。补写后必须运行 `python scripts/count_chars.py <受影响文件或formal-draft>`，并在 `progress.md` 记录 `修前字数 / 修后字数 / 最低字数 / 是否达标`。
- 若 review 指出项目建设方案、项目研发内容、技术路线、成果或指标不像附件公文写法，必须按 `attachment-writing-patterns.md` 的段落骨架重写，不得只替换几个词
- 若 review 指出两类正文章节“调研未消费”“文风过泛/过满”“编号方案未执行”，默认动作不是局部润色，而是先为受影响小节重新抽取证据清单，再回到对应正文 skill 重写该小节
- 若 review 指出调研组来源数量或证据卡未达标，不能只改正文，应先回到 `official-doc-research` 补齐来源、证据卡、摘记和事实台账；补齐前不得把 Must Fix 关闭
- 若 review 指出 `**子任务...**`、`**技术描述...**` 等加粗伪标题，必须改为规范 Markdown 标题层级或自然段引导句，并重新运行 `style_check.ps1`
- 若 review 指出普通章节存在连续 `### 11.`、`### 12.`、`### 13.` 等流水号标题、重复标题、泛化展望标题，必须先合并或删除标题，再把有效内容并入 `00-section-plan.md` 允许的小节自然段中；不得保留标题后只润色正文
- 若 review 或脚本命中“术语污染/错词”（如 `C广告matic`），必须统一修正为规范术语并全稿排查同类错写
- 若 review 或脚本命中“复杂度/公式残句”（如 `在的时间复杂度内`、`复杂度降至约，其中`），必须改成完整可读工程表述；无法严谨给公式时改为保守文字说明
- 若 review 命中“强结论无支撑”（如 `填补国内技术空白`、`国际领先`、`首创`），必须回查 `facts-ledger.md` 与来源等级，不满足支撑时降级为保守表述
- 若章节存在大段同义反复或堆字数扩写，必须做压重写：保留有效事实与机制，删除重复价值宣示

## 专项回修路由

回修或扩充两类正文内容时，`official-doc-revise` 不能独立发挥，必须先读取并执行对应正文 skill 的规则，再改文件：

- 建设背景、建设意义、国内外发展现状及前景、国内/国外现状、痛点分析、发展前景、必要性、产业链安全、自主可控：读取并遵守 `.claude/skills/official-doc-project-background/SKILL.md`
- 项目建设方案、总体目标、建设目标、项目解决的主要问题、项目研发内容、预期成果、产业链供应链韧性及安全保障、技术路线、应用推广方案、产学研用合作方式、攻关成果开源策略、任务设置、任务分解、实施内容：读取并遵守 `.claude/skills/official-doc-research-content/SKILL.md`

若同一段同时属于背景和项目建设方案两类内容，必须同时读取相关 skill，并按更严格的规则处理。回修结论中应说明本次使用了哪些专项规则。

注意：写作阶段曾经加载过对应正文 skill，不代表 revise 阶段可以继承使用。`official-doc-revise` 命中两类正文专项内容时，当前回修阶段必须由主控代理重新显式加载对应正文 skill，不能把“前一轮写正文时已经加载过”当成当前回修的有效前提。

只要本轮 revise 修改了两类正文专项章节中的任一文件，主控就必须在 `workspace/plan/<project-slug>/progress.md` 明确追加一条独立留痕，字段至少包括：

- `本轮 revise 加载的正文 skill`
- `对应受影响文件 / 小节`
- `本轮为何需要重新加载该 skill`
- `本轮证据清单摘要`
- `本轮规则摘要`

若 `progress.md` 中缺少上述留痕，不得把这次专项回修判为完成，也不得进入 assemble / final review。
主控在结束 revise 之前，必须亲自检查 `progress.md` 中是否已经出现一条实际的 `本轮 revise 加载的正文 skill` 记录；若没有，不得把 revise 标记为完成，也不得把问题推迟到“下轮再补”。

若本轮 revise 是“扩写”而不是“修错”，但受影响文件仍命中两类正文专项内容，上述重载要求仍然成立。不得把“只是补字数/补几段”当成绕过对应正文 skill 的理由。

若 review 指出的问题属于以下任一类型，且受影响文件命中两类正文专项内容，`official-doc-revise` 不得只做自由改句，必须按“专项重写”处理：

- 标题编号混乱，且需要把内容重新并入既定小节
- 调研已存在，但正文没有真正消费证据
- 段落明显泛、满、口号化，需要压重写
- 项目建设方案的骨架不成立

“专项重写”的最低要求是：

1. 先重新显式加载对应正文 skill。
2. 再从 `source-materials.md`、`project-brief.md`、`research-evidence.md`、`research-notes.md`、`facts-ledger.md` 为受影响小节重新抽取证据清单，且必须区分 `用户给定项目事实` 与 `外部调研补充依据`。
3. 提炼当前小节适用的编号规则、句式骨架和禁止项。
4. 按该 skill 的句式骨架和编号规则重写。
5. 若抽不出足够证据点，不得继续润色，应先回到 `official-doc-research` 补证。
6. 回修完成后在 `progress.md` 记录：受影响小节、使用的专项 skill、证据清单摘要、规则摘要、是否需要重新装配。
7. revise 阶段不得派发子代理，也不得新增 `agent-skill-trace.md` 的 revise 任务记录；该台账只用于核验 research 之后的正文章节写作子代理是否按要求加载了对应 skill。
8. 若章节中仍残留 `【来源：...】`、`来源：原始资料`、内部来源编号或调研映射说明，必须在回修时一并清除；不得把污染内容原样保留到装配阶段。

专项回修的最低动作：

1. 先按 `00-section-plan.md` 确认允许标题层级。
2. 重新显式加载对应正文 skill。
3. 为受影响小节抽取证据清单，确认可用事实、比较、机制、输出和验证口径。
4. 删除或合并计划外标题、流水号标题和重复标题。
5. 按对应正文 skill 的骨架重写，并补齐“对象、问题、动作、机制、输出、验证”。
6. 确认成果、指标能回指项目研发内容或建设任务。
7. 在 `progress.md` 追加一条“本轮 revise 加载的正文 skill”留痕，至少写明：skill 名称、受影响文件/小节、证据清单摘要、规则摘要。
8. 清除正文中的内部来源标记、检索说明残留和计划外污染小节。
9. 运行 `style_check.ps1`，若命中硬失败项继续回修。

若本轮 revise 修改了两类正文专项章节，而结束时 `progress.md` 仍未出现上述记录，则说明并未真正按专项回修流程执行。此时不得写“已完成回修”“Must Fix清零”，而应直接判定 revise 未完成。

## 回修阶段不派子代理

`official-doc-revise` 必须由主控代理直接执行，不得并行派发子代理。原因是回修阶段需要统一仲裁 Must Fix 的优先级、协调跨章编号和事实口径，并决定哪些内容应删除、并入还是重写，这些动作不适合再分散给子代理。

因此：

- 不得按章节、问题类型或内容类型继续拆分回修子任务
- 不得生成 revise 子代理任务单
- 不得在 revise 阶段新增 `agent-skill-trace.md` 记录
- 若 review 已指出“专项 skill 调用留痕缺失”或当前散件明显违背对应正文 skill 的硬规则，主控应直接重新加载对应正文 skill 并重写相关小节，而不是再派子代理补救

## 回修顺序

默认按以下顺序推进：

1. 修调研门禁问题，补齐来源、证据卡、摘记和事实台账
2. 修标题、编号、固定模板结构错误，删除或合并计划外二级节，并补齐或执行全文编号方案
3. 修章节配比问题
4. 修写作深度问题，补齐论证链和章节内部因果关系
5. 补高优先表图缺失
6. 修正文与表图引用、术语、数字口径
7. 修来源证据档案、事实台账与进度记录
8. 运行风格检查，确认明显 AI 痕迹已清理

不要一上来就只改文字表述，先解决结构性问题。

## 典型修订动作

- 标题与编号修订
- 正文与表图引用统一
- 项目名称、单位、负责人、周期、预算等口径统一
- 将 review 指出的空泛段落改成更贴近模板要求的正式表述
- 将“打造平台、赋能业务、形成闭环、提升效率”等口号化段落改成“对象、问题、机制、输出、验证”齐全的论证段落
- 将缺失说明补回台账，而不是只在对话中说明
- 将列表化正文、加粗小标签和机械过渡词改写为连续自然段

## 回修优先级

若 review 指出以下问题，应按此顺序修：

1. 标题、编号、章节结构错误
2. 事实与来源等级错误
3. 总字数或章节轻重失衡
4. 缺失表图或装配位置错误
5. 正文与表图引用、术语、数字口径不一致
6. 已知事实被回退成 `【待补】`
7. 语言、风格、冗余重复问题

## 风格回修后的检查

正文回修后，优先运行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/style_check.ps1 -FilePath <文件路径>
```

如果脚本仍命中以下项，默认说明回修未完成：

- 正文列表行
- 正文加粗小标签
- 机械过渡词

## 与 table / figure skill 的协同

如果 review 明确指出某个高优先表图缺失，不要只在 review 文件里标记“待补”：

- 缺高优先表时，应主动调用 `official-doc-table`
- 缺高优先图时，应主动调用 `official-doc-figure`
- 表图补齐后，必须回修正文中的引用句、编号和说明文字
- 回修默认以“当前受影响章节”为单位推进：
  - 先修正文
  - 再修本章表图
  - 再修引用、术语和口径
  - 不要在一次回修里顺手扩写多个未计划章节

`revise` 的职责不是回避补件，而是把 review 发现的问题真正落到文件上。

## 交付要求

至少说明：

- 已修复哪些问题
- 哪些问题因材料缺失仍保留 `【待补】`
- 当前是否可以进入 `official-doc-assemble`

若这些问题来自装配后 final review，还要明确说明：

- 是否需要重新装配
- 哪些修订会直接影响当前 `formal-draft`

如果仍不能进入 `official-doc-assemble`，要明确列出剩余阻断项：

- 未修复的 Must Fix
- 未补齐的高优先表图
- 仍失衡的重章节 / 轻章节

## 交付后动作

- 更新 `workspace/plan/progress.md`
- 若 Must Fix 已处理完，默认下一步进入 `official-doc-assemble`

