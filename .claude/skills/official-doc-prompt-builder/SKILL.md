---
name: official-doc-prompt-builder
description: 正式中文项目公文写作的前置问询与 prompt 组装入口。用于通过分组问答采集用户输入，组装标准长 prompt，并默认把结果交给 using-official-docs 继续执行后续写作 skill 链。
allowed-tools: Read Write Edit Bash
---

# official-doc-prompt-builder

## 定位

这是 `using-official-docs` 之前的前置 intake skill。

它只负责四件事：
1. 识别文种与任务目标
2. 按固定分组采集用户输入
3. 把输入组装成标准长 prompt
4. 把 prompt 交给 `using-official-docs`

它不负责：
- 调研
- 正文写作
- review
- revise
- assemble
- 本地文件自动解析为主流程

## 适用场景

当用户属于以下任一情况时，应优先使用本 skill：
- 只有项目主题，尚未整理成长 prompt
- 明确问“提示词怎么写”“要输入哪些信息”“能不能做成问答模板”
- 手头有零散材料，但还没整理成结构化 brief
- 想先得到一份可复用的正式 prompt，再决定是否继续写作

若用户已经提供了完整长 prompt、章节表、原始资料和输出约束，则不必走本 skill，直接进入 `using-official-docs`。

## 总原则

### 1. 只做 intake，不做写作

本 skill 的目标不是“直接把报告写出来”，而是“把用户信息整理成后续写作可直接消费的 prompt”。

### 2. 问答按 5 组固定采集

不要按章节逐条碎问。按以下 5 组采集：

1. 文档元信息
2. 结构与输出约束
3. 全局写作要求
4. 章节原始资料
5. 图表与缺失信息

每组问完后，先做一轮压缩整理，再进入下一组。

### 3. 缺失信息不补造

用户未提供的信息统一记为 `待补充`：
- `prompt-intake.md` 中写 `待补充`
- `compiled-prompt.txt` 中明确要求按 `待补充` 保留框架和测算逻辑

不得自行推断：
- 金额
- 周期
- 人员
- 指标值
- 验收口径

### 4. 默认继续交接

完成 prompt 组装后：
- 默认继续把 `compiled-prompt.txt` 交给 `using-official-docs`
- 只有用户明确说“只帮我整理 prompt，不要继续写”时，才停在 intake 阶段

## 文种预设

在通用骨架上，根据用户文种选择以下预设之一：
- 可行性报告
- 立项申请书
- 项目建议书
- 攻关任务书
- 技术总结
- 自定义结构

不要为每种文种设计完全不同的问卷。共用同一采集框架，只切换：
- 章节结构预设
- 默认编号方案
- 少量默认约束语句

## 固定输出骨架

组装后的 `compiled-prompt.txt` 必须统一包含以下 5 段：

1. 任务定义
2. 写作总要求
3. 原始资料必须吸收
4. 分章节原始资料与写作要求
5. 输出形式要求

目标是让生成结果尽量接近用户当前手写长 prompt 的强度和结构，而不是一份简版提纲。

## 5 组采集要求

### 第一组：文档元信息

至少采集：
- 公文类型
- 项目名称
- `project-slug`（若用户未给，则按项目名称生成）
- 建设任务/专题数量
- 目标总字数
- 是否要求深度调研
- 是否要求正式、克制、工程化口径

### 第二组：结构与输出约束

至少采集：
- 章节顺序
- 二级节结构
- 是否固定编号方案
- 是否必须含图/表
- 是否需要 `待补充` 占位策略

### 第三组：全局写作要求

至少采集：
- 哪些内容必须先查公开资料
- 哪些信息不得编造
- 创新点、成果、指标之间的约束关系
- 是否允许输出“检索与资料映射说明”

默认应写明：正式正文不得暴露内部来源标记和检索映射说明。

### 第四组：章节原始资料

按章节或章节组采集。每章至少要整理：
- 已有资料
- 必保留内容
- 特别要求
- 待补信息

若该章属于项目建设方案 / 创新点等重章节，还必须额外采集：
- 是否已有建设目标、主要问题和项目研发任务拆分
- 是否已有技术路线、应用推广、产学研用合作或开源策略要求
- 是否已有创新点草案
- 是否已有公式、伪代码、流程图、变量关系、规则链、参数化描述
- 是否必须配图或配表

### 第五组：图表与缺失信息

至少采集：
- 哪些图表必须生成
- 哪些字段仍待补充
- 是否存在金额、人员、周期等未定信息

## 文件落位

本 skill 必须输出两份文件，统一写入：

- `workspace/intake/<project-slug>/prompt-intake.md`
- `workspace/intake/<project-slug>/compiled-prompt.txt`

含义固定：
- `prompt-intake.md`：结构化记录用户回答、分组整理结果和待补项
- `compiled-prompt.txt`：最终组装好的正式长 prompt

不得把提示词临时写到 `workspace/assembled/`。

## prompt-intake.md 写法

`prompt-intake.md` 至少包含：
- 项目基本信息
- 文种预设
- 5 组问答整理结果
- 待补信息清单
- 是否继续交接给 `using-official-docs`

它是回看和补问台账，不是最终写作 prompt。

## compiled-prompt.txt 写法

`compiled-prompt.txt` 应是用户可直接复用的长 prompt。

必须具备这些特征：
- 使用正式中文
- 写清任务目标
- 写清全局写作总要求
- 写清哪些原始资料必须吸收
- 按章节列出资料与要求
- 写清输出形式和禁入项
- 对缺失字段统一写 `待补充`

如果用户给出的原始输入很短，不得只拼成一句“请写一份可行性报告”。必须把 5 组问答整理后再形成可执行 prompt。

## 与 using-official-docs 的交接

### 默认模式

若用户没有明确要求“只生成 prompt”，本 skill 完成后必须继续做两件事：
1. 明确告知已写入：
   - `workspace/intake/<project-slug>/prompt-intake.md`
   - `workspace/intake/<project-slug>/compiled-prompt.txt`
2. 指示后续正式写作应进入 `/using-official-docs`，并以 `compiled-prompt.txt` 作为输入

### 仅生成 prompt 模式

若用户明确说“只帮我整理 prompt，不要继续写”：
- 只生成上述两份 intake 文件
- 不进入 `using-official-docs`

## 与 using-official-docs 的边界

本 skill 不直接替代 `using-official-docs`。

分工是：
- `official-doc-prompt-builder`：采集输入、组装 prompt
- `using-official-docs`：正式执行调研、写作、表图、review、revise、assemble

如果当前用户输入明显过短、只有主题或只有一句话需求，本 skill 应被优先建议或先行使用；不应让 `using-official-docs` 直接硬写。

## 最低质量要求

完成前至少自查：
- 是否完成了 5 组采集，而不是只问了项目名
- 是否已区分文种预设
- 是否已把缺失字段统一处理为 `待补充`
- 是否已对项目建设方案/创新点类章节额外采集细化信息
- 是否已生成 `prompt-intake.md`
- 是否已生成 `compiled-prompt.txt`
- 是否已明确默认后续应进入 `using-official-docs`

如果最后没有生成可直接复用的长 prompt，只生成了几条问题或一份简短提纲，说明本 skill 执行失败。
