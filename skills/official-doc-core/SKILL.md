---
name: official-doc-core
description: Use before writing any formal Chinese project document in this plugin. It enforces prompt-driven workflow, fact discipline, project-slug workspace conventions, source logging, section dependency checks, and the rule that the five shared chapter types must be grounded in web research instead of fabrication.
allowed-tools: Read Write Edit Bash
---

# 公文写作通用规则

> 2026-04 架构更新：以下规则优先于全文旧内容。凡提到 `ZS`、`完整科研项目模板`、`templates/`、固定 catalog、固定模板结构的旧规则，一律忽略。
>
> 当前通用规则改为：
> - 以用户提示词为主，不再以固定模板为主
> - 工作区按 `workspace/<kind>/<project-slug>/` 隔离
> - 五类共性章节必须先做网络搜索，并把来源登记到 `workspace/plan/<project-slug>/research-sources.md`
> - `创新点` 必须能回指现状与研究内容
> - `技术成果` 必须由研究内容推出
> - `技术指标` 必须可量化、可测试

这是当前提示词驱动项目写作流程的公共规则层。

## 一、最重要的执行原则

### 1. brief 先于措辞
必须先服从用户提示词拆出的章节要求，再考虑语言润色。

### 1.5 流程先于提问
当下一步可以根据当前文件状态、模板规则和台账自动判断时，不要把流程分支问题再抛回给用户。
例如不要询问：
- 先 review 还是先继续写
- 先补表还是先补图
- 是否现在 assemble

### 2. 事实先于完整
材料不够时，不补造信息；用 `【待补】` 显式占位。

### 3. 台账先于口头说明
发现任何缺口、冲突、暂缺数据，都要回写到 `workspace/plan/`，不能只在对话里说。

### 3.5 用户字数要求先于默认篇幅
如果用户明确给出“总字数 / 篇幅 / 控制在多少字 / 不少于多少字 / 不超过多少字”等要求，必须把它视为硬约束。
不要继续只按“中等篇幅”或模板默认体量自由发挥。

### 4. 表图先于长段堆砌
适合用表表达的，不强行写成一大段；适合用图表达的，不强行塞进正文。

### 5. 模板与 Skill 先于参考样稿
对于本插件支持的两类文档，结构、风格、流程优先来自：
- 对应 `templates/<template>/` 文件
- 对应主 Skill
- 当前公共 Skill

默认不向用户追问参考样稿。

## 二、标题规则

### 强固定层
- 一级标题默认不得修改
- 二级标题默认不得修改
- 模板中已明确给出的固定三级标题默认不得修改

### 允许细化层
- 若模板未固定更深层级，可围绕既有上位标题补充三级或四级小标题
- 新增小标题必须服务既有章节逻辑，不能替代固定标题

### 材料不足时的处理
- 不删标题
- 不改标题
- 不合并固定章节
- 在相应位置写 `【待补：缺少什么材料】`

## 三、事实纪律

不得编造以下内容：
- 项目名称
- 单位名称
- 负责人姓名与职务
- 项目起止时间
- 任务节点
- 金额、投资、预算、效益数字
- 成果数量与成员构成

遇到信息不充分时：
1. 正文标 `【待补】`
2. `workspace/plan/facts-ledger.md` 记录缺口
3. `workspace/plan/source-materials.md` 记录需要补充的材料来源

若用户给出字数要求，还应：
4. 在 `workspace/plan/project-overview.md` 记录目标总字数
5. 在 `workspace/plan/progress.md` 记录本轮目标总字数与当前适配状态

## 四、语言风格

### 适用范围
本插件默认服务正式中文项目材料。

### 风格要求
- 正式、克制、书面化
- 以连续段落为主，不写聊天式口吻
- 不写口号式、宣传式空话
- 不夸大项目价值，不把预期写成既成事实
- 可研/申报阶段优先使用“拟”“计划”“预期”“将”这类表述

### 段落要求
- 每段围绕一个中心意思展开
- 不把整章写成要点堆砌
- 但在计划、任务、风险、检查清单等场景允许使用列表

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
- `workspace/plan/project-overview.md`
- `workspace/plan/source-materials.md`
- `workspace/plan/facts-ledger.md`
- `workspace/plan/progress.md`

## 六、执行留痕

`official-doc-core` 不是隐形背景规则，而是需要显式执行的一步。

当你调用本 Skill 后，必须在 `workspace/plan/progress.md` 留下本轮执行痕迹，至少说明：
- 本轮已执行 `official-doc-core`
- 对应模板是什么
- 用户是否给出了总字数要求；若给出，目标总字数是多少
- 下一步将进入哪个主 Skill 或公共 Skill

不要把“脑中已经参考了 core 规则”当作已经执行完成。

## 七、阶段门禁

### 对所有新任务，默认执行顺序为：
1. 判定模板
2. 读取模板文件
3. 创建或复用工作区
4. 更新 plan 台账（含目标总字数，如有）
5. 生成骨架
6. 生成正文
7. 补表格
8. 补图示
9. 复核
10. 回修
11. 装配正式总稿

### 对继续推进任务，默认执行顺序为：
1. 读取已有 `workspace/outputs/ workspace/tables/ workspace/figures/ workspace/review/ workspace/assembled/ workspace/plan/`
2. 判断当前最合理的下一步
3. 继续推进缺失环节

### 本层只做通用门禁

`official-doc-core` 只定义跨模板共用的阶段顺序，不定义：
- 某个模板第几章之后先补哪张表
- 某个模板图1或图4-1应采用什么拓扑
- 某个模板哪一章应占多少比例

这些规则分别由以下层负责：
- 正文与章节配比：对应主 Skill 与 `writing-playbook.md`
- 表格顺序与字段：`official-doc-table` 与 `table-catalog.md`
- 图示顺序与图型：`official-doc-figure` 与 `figure-catalog.md`
- 是否通过验收：`official-doc-review`

## 八、表图规则

### 表格
- caption 与模板目录一致
- 表头尽量遵从模板字段
- 数值、时间、单位与正文一致
- 输出到 `workspace/tables/<template>/`

### 图示
- 图名与正文引用一致
- 节点术语与正文一致
- 一张图只回答一个主问题
- 输出到 `workspace/figures/<template>/`

### 正文中如何处理
正文只保留：
- `此处引用表X` 或 `此处引用图X`
- 不在正文里替代表图硬写一大段说明

## 九、何时默认推进下一步

当你完成当前阶段或当前章节正文后：
- 若章节已出现表格引用位，应主动推进 `official-doc-table`
- 若章节已出现图示引用位，应主动推进 `official-doc-figure`
- 若这一轮产出准备交付，应主动推进 `official-doc-review`
- 若 review 已产出明确问题，应主动推进 `official-doc-revise`
- 只有在全书必需章节、必需表图和回修均已完成时，才应主动推进 `official-doc-assemble`

## 十、关于顺序的职责划分

若需要判断“下一张先补哪张表 / 图”，不要在本层自行决定。

应按以下顺序取规则：
1. 对应主 Skill
2. 对应 `table-catalog.md` / `figure-catalog.md`
3. `official-doc-table` / `official-doc-figure`
4. `official-doc-review` 的验收结果

本层只要求：
- 不要跳过明显缺失的关键表图
- 不要在 review 前跳过当前阶段应完成的核心散件
- 不要在 revise 未完成时直接宣称最终交付

## 十一、完成判定

你准备声称“这一轮已完成”之前，至少要确认：
- 输出文件已写入目标目录
- `workspace/plan/progress.md` 已更新
- 当前阶段未处理的 `【待补】` 已在台账中记录
- 若用户目标是交付正式稿，`workspace/assembled/<template>/` 下已生成装配后的总稿
- 若用户给出了总字数要求，当前成稿总字数与目标偏差已被检查并记录
