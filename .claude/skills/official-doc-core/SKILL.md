---
name: official-doc-core
description: 项目公文写作的公共校验层。仅在 using-official-docs 完成 brief 解析和工作区初始化后使用，用于检查台账、事实纪律、阶段顺序、章节依赖、正式文风和写作深度门禁。它不创建工作区，不首次写 plan，也不直接联网搜索或写两类共性章节。
allowed-tools: Read Write Edit Bash
---

# 公文写作通用规则

> 当前项目只使用提示词驱动流程。
>
> 当前通用规则是：
> - 以 `project-brief.md` 和 `00-section-plan.md` 为准
> - 工作区按 `workspace/<kind>/<project-slug>/` 隔离
> - 背景和项目建设方案两类共性章节先过 `official-doc-research` 调研门禁、先落账、后写作

这是当前写作流程的公共门禁层。

涉及正式正文写法时，读取：
- [references/formal-doc-style.md](./references/formal-doc-style.md)
- [references/attachment-writing-patterns.md](./references/attachment-writing-patterns.md)
- [references/depth-writing-rules.md](./references/depth-writing-rules.md)
- [references/depth-writing-examples.md](./references/depth-writing-examples.md)
- [references/subagent-task-card-template.md](./references/subagent-task-card-template.md)

## 一、执行原则

### 1. brief 先于措辞
先服从用户提示词拆出的章节、图表、字数和风格要求，再考虑润色。

若用户给出长 prompt，`source-materials.md` 必须保存完整提示词和分组项目资料，`project-brief.md` 必须保存从提示词拆出的硬约束。core 校验时如果发现 `source-materials.md` 只有摘要、没有项目资料分组，或没有记录“禁止参照外部模板文件”等用户硬约束，应返回 `using-official-docs` 重新初始化，不得放行调研或写作。

长 prompt 项目还必须完成资料证据化。core 校验时如果发现：
- `source-materials.md` 没有 `章节资料映射` 或等价分章资料摘录；
- `facts-ledger.md` 没有 USER 系列或等价的 `用户提示词` 项目事实记录；
- `00-section-plan.md` 没有每章可用项目资料摘要；
- `project-brief.md` 没有记录“只基于提示词内项目资料”“禁止外部模板文件”等硬约束；
则应返回 `using-official-docs` 重新初始化或补台账，不得放行调研、写作、review 或 assemble。

### 2. 流程先于提问
当下一步可以根据工作区状态自动判断时，不要把流程分支问题抛回给用户。

### 3. 事实先于完整
材料不够时，不补造信息；用 `【待补】` 显式占位，并同步回写台账。

### 4. 台账先于口头说明
任何缺口、冲突、阻断原因，都要回写到 `workspace/plan/<project-slug>/`，不能只在对话里说。

### 5. 用户字数要求是硬约束
如果用户明确给出总字数、上下限或篇幅要求，必须把它视为硬约束。

core 校验时必须确认：
- `project-brief.md` 已拆出 `总字数下限 / 总字数上限 / 统计口径`。如果用户给出“全文总字数控制在X至Y”，X 是硬下限，Y 是硬上限。
- `00-section-plan.md` 已为每章登记 `目标字数区间 / 最低字数 / 是否硬门槛`。如果用户给出“建议X至Y、最低不得少于Z”，Z 是硬下限；如果只有“建议X至Y”，X 是硬下限。
- 写作子代理任务单不能只写“本章目标字数”，必须同时写 `本章最低字数` 和 `低于最低字数不得提交完成`。
- 若上述字段缺失，core 必须返回 `using-official-docs` 补计划，不得放行调研、写作、review 或 assemble。

### 6. 表图服务正文，不替代正文
适合用表表达的，不硬写成长段；适合用图表达的，不把图的逻辑塞回正文。

### 7. 正文必须像正式公文，不像演示稿或 AI 草稿
正文默认写成连续自然段，不写成项目符号堆砌，不写成加粗小标签拼贴，不写成机械的多级目录摘抄。

`attachment-writing-patterns.md` 中的“常用写法”是硬约束，不是参考材料。两类共性正文和回修正文必须覆盖各自关键要素，不能只写“意义重大、形成体系、提升能力”。

### 7.5 正文必须有论证深度
两类共性章节写作前，必须先建立“章节论证链”，至少说明本章核心判断、事实依据、差距问题、技术机制、输出结果和边界条件。若论证链填不实，不得靠空泛扩写凑字数，应回到 `official-doc-research` 补调研，或只向用户提出一个会影响方向的关键问题。

### 7.6 编号必须由文档级方案统筹
`using-official-docs` 应在 `project-brief.md` 和 `00-section-plan.md` 中记录全文编号方案。core 校验时要确认两个专项章节没有各自混用编号层级。

默认正式报告型编号为：一级章 `一、`，二级节 `（一）`，三级项 `1.`，四级点 `（1）`。若项目建设方案中的项目研发内容需要任务化下钻，可在该节内部采用 `任务1 / 子任务1-1`，但不得与同层级 `（1）` 混用。

`00-section-plan.md` 必须区分用户原始章次和正式输出标题。正式报告型材料中，用户写“第一章”不等于正式稿输出“第一章”；正式输出标题应按 `一、`、`二、` 执行。core 发现计划文件没有 `正式输出标题` 或计划允许小节不清时，应返回 `using-official-docs` 补计划，不要放行写作。

正文不得为了补字数新增计划外二级节。任何章节 skill 或主入口写作前，都要先确认该章允许出现哪些二级节；未登记的二级节不得写入散件文件。

正文也不得靠连续追加 `### 10.`、`### 11.`、`### 12.` 等流水号标题扩写。普通章节需要补深度时，应合并到既定二级节下的自然段、表格说明和少量必要三级标题中；不得追加 `远景展望`、`总结与展望`、`历史意义`、`人才培养` 等与章节计划无关的泛化标题。

### 8. core 不代替专项 skill
`official-doc-core` 只做公共校验，不代替：
- `official-doc-research`
- `official-doc-project-background`
- `official-doc-research-content`

若当前章节命中上述两类之一，core 执行后下一步必须先进入 `official-doc-research`，再显式加载对应专项 skill，而不是由 core 自己搜索或写作。

### 8.5 子代理总守则（环境支持时）
若运行环境支持子代理（如 Claude Code），只允许在 `official-doc-research` 与正文章节写作阶段并行；`review`、`revise`、`assemble` 不得使用子代理。并行时必须遵守以下统一约束：
- 主控代理必须保留最终决策权，子代理不能单独判定“可交付正式稿”。
- 子代理开工前必须读取：`project-brief.md`、`00-section-plan.md`、`attachment-writing-patterns.md`、对应专项 skill。
- 若运行环境支持 skill 显式调用，命中专项内容的子代理还必须先执行任务单 `【显式 skill 调用指令】` 中列出的命令；仅手动读取 `SKILL.md` 文件不算完成 skill 调用。
- 子代理任务单应按 `references/subagent-task-card-template.md` 填写，字段不可删减。
- 写作子代理的可见 Prompt 前部必须直接出现 `【专项 skill 调用要求】`、`【显式 skill 调用指令】` 与 `【开工第一步】`；若看不到这三个区块，视为任务单不合格。
- 若运行环境会显示 `Skill(...)`、`Successfully loaded skill` 或 slash 命令回显，主控应把它当作优先证据；若前 3 个可见动作内没有出现对应事件，视为派发失败并重派。
- 子代理不得跳过调研门禁，不得新增计划外二级节，不得自行改写全文编号方案。
- 每个子代理必须有独占文件范围，避免多人同时改同一文件。
- 子代理提交后，主控代理必须先检查“已显式加载的 skill 清单与顺序”或“本任务不需要显式加载专项写作 skill”的声明是否完整，再执行脚本检查和人工抽检；若缺失，视为派发失败并重派。

## 二、core 的职责边界

### core 负责
- 校验 `workspace/plan/<project-slug>/` 与各类工作区目录是否存在
- 校验以下文件是否存在且可读：
  - `project-overview.md`
  - `project-brief.md`
  - `research-plan.md`
  - `research-sources.md`
  - `research-evidence.md`
  - `research-notes.md`
  - `facts-ledger.md`
  - `progress.md`
  - `source-materials.md`
  - `workspace/outputs/<project-slug>/00-section-plan.md`
- 校验调研总账已经合并完成：若存在 `workspace/plan/<project-slug>/research-drafts/`，但 `research-evidence.md`、`research-notes.md` 仍缺失，或明显只有分组草稿未合并，则不得放行
- 校验 `source-materials.md` 是否保存用户提示词原文或完整项目资料分组；若缺失，不能只依靠联网调研继续写
- 校验事实纪律、阶段顺序、文件路径、章节依赖关系

### core 不负责
- 初始化工作区
- 首次写入 plan 台账
- 直接发起网络搜索
- 直接起草专项章节正文
- 决定具体哪张表或哪张图的内容细节

若目录或文件缺失，应返回 `using-official-docs` 先补初始化，而不是由 core 代建。

## 三、事实纪律

不得编造以下内容：
- 项目名称
- 单位名称
- 负责人姓名与职务
- 项目起止时间
- 任务节点
- 金额、预算、效益数字
- 成果数量与成员构成

遇到信息不充分时：
1. 正文标 `【待补】`
2. `facts-ledger.md` 记录缺口
3. `source-materials.md` 记录待补来源
4. 若缺口来自已有来源抓取不充分，`research-evidence.md` 记录证据不足原因

## 四、语言与结构

### 风格要求
- 正式、克制、书面化
- 不写口号式、宣传式空话
- 不把预期写成既成事实
- 申报阶段优先使用“拟”“计划”“预期”“将”等表述

### 正文形态要求
- 正文默认不用项目符号列表
- 正文默认不用 `**技术描述**`、`**技术难点**`、`**作用**` 这类加粗小标签
- 正文默认不用演示稿式短句堆叠
- 二级标题下优先写 1 到 3 个完整自然段，而不是把提示词拆成一串点

### 禁用 AI 痕迹
- 机械过渡词：`首先、其次、最后、此外、另外、接下来、总之`
- 空壳强调句：`值得注意的是、需要指出的是、重要的是、必须强调的是`
- 空泛表述：`显著提升`、`大幅优化`、`有效赋能`，若没有对应依据或对象，不应单独出现

### 正确与错误示例

错误：

```md
**技术描述**：研究自动化训练样本生成技术。

**技术难点**：样本与工程场景一致性不足。

**作用**：为后续模型训练提供支撑。
```

正确：

```md
针对训练样本不足的问题，项目拟研究自动化训练样本生成技术，通过参数化模板和批处理机制提升样本构建效率。该技术的关键在于保持生成样本与工程场景的一致性，避免样本分布偏移。相关成果将为后续模型训练提供稳定的数据基础，并支撑分类性能的持续优化。
```

错误：

```md
本章主要包括：
- 背景
- 意义
- 现状前景
```

正确：

```md
项目背景及必要性宜按照“建设背景、建设意义、国内外发展现状及前景”递进展开。建设背景先交代政策环境、产业地位、外部压力和本项目切入；建设意义再从技术层面、产业层面、生态层面说明项目能够解决什么问题、形成什么能力、带动什么协同；国内外发展现状及前景则围绕国内基础、国外产品与应用、痛点分析和发展趋势展开，为后续项目建设方案提供依据。
```

### 标题要求
- 一级标题与用户要求保持一致
- 二级标题优先服从用户指定的小节结构
- 若用户未固定更深层级，可补充三级小标题，但必须服务现有逻辑
- 材料不足时不删标题，只在对应位置补 `【待补】`
- 标题编号必须服从文档级编号方案，不允许某章用 `（1）`、另一章同层级用 `1.1`

## 五、工作区约定

必须维护以下目录：

```text
workspace/
  plan/
  outputs/
  tables/
  figures/
  review/
  assembled/
```

必须维护以下文件：
- `workspace/plan/<project-slug>/project-overview.md`
- `workspace/plan/<project-slug>/project-brief.md`
- `workspace/plan/<project-slug>/stage-gates.md`
- `workspace/plan/<project-slug>/research-plan.md`
- `workspace/plan/<project-slug>/research-sources.md`
- `workspace/plan/<project-slug>/research-evidence.md`
- `workspace/plan/<project-slug>/research-notes.md`
- `workspace/plan/<project-slug>/source-materials.md`
- `workspace/plan/<project-slug>/facts-ledger.md`
- `workspace/plan/<project-slug>/progress.md`
- `workspace/outputs/<project-slug>/00-section-plan.md`

## 六、执行留痕

调用本 skill 后，必须在 `workspace/plan/<project-slug>/progress.md` 留痕，至少说明：
- 本轮已执行 `official-doc-core`
- 工作区与台账校验是否通过
- 用户是否给出总字数要求
- `stage-gates.md` 当前推进到哪一关
- 下一步将进入哪个专项 skill 或公共 skill

`已执行 official-doc-core` 不等于 `已执行专项章节 skill`。

## 七、阶段门禁

### 新任务顺序
1. `using-official-docs` 解析 brief 并初始化工作区
2. `using-official-docs` 初始化台账
3. `official-doc-core` 校验前置条件
4. `official-doc-research` 完成调研门禁
5. 识别各章是否命中专项 skill
6. 命中则加载专项 skill
7. 生成正文
8. 补表
9. 补图
10. review
11. revise
12. assemble

### 继续推进顺序
1. 读取现有 `workspace/plan/ outputs/ tables/ figures/ review/ assembled/`
2. 判断当前最合理的下一步
3. 推进缺失环节

## 八、表图处理

### 表格
- 标题、字段、单位与正文一致
- 输出到 `workspace/tables/<project-slug>/`

### 图示
- 图名、节点术语与正文一致
- 一张图只回答一个主问题
- 输出到 `workspace/figures/<project-slug>/`

### 正文中的处理
正文只保留正常引表引图语句，不要用大段描述去替代表图。

## 九、默认推进规则

当当前阶段完成后：
- 若章节已出现表格需求，应推进 `official-doc-table`
- 若章节已出现图示需求，应推进 `official-doc-figure`
- 若本轮产出准备交付，应推进 `official-doc-review`
- 若 review 已产出问题，应推进 `official-doc-revise`
- 只有在正文、表图、回修都完成后，才推进 `official-doc-assemble`

## 十、完成判定

准备声称“这一轮已完成”之前，至少确认：
- 输出文件已写入正确目录
- `progress.md` 已更新
- 未解决的 `【待补】` 已在台账中记录
- 若用户目标是正式稿，`workspace/assembled/<project-slug>/formal-draft.md` 已生成
- 若用户给出了总字数要求，当前总字数与目标偏差已被检查并记录
