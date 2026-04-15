---
name: official-doc-review
description: Use when the current official-document workflow reaches a review point or the user asks to check the draft - reviews ZS-项目可行性报告 or 完整科研项目模板 for headings, numbering, terminology, tables, figures, schedule, budget, unresolved placeholders, and revise readiness
allowed-tools: Read Write Edit Bash
---

# 公文复核 Skill

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- 用户明确要求检查、复核、体检、定稿前核验
- 当前一轮正文、表格、图示已经生成，需要阶段性检查
- 你准备告诉用户“这一轮已完成”
- `official-doc-assemble` 刚刚完成，需对 `formal-draft` 做装配后 final review

## 核心目标

对已经生成的骨架、正文、表格、图示做结构化体检，输出可执行的问题清单，而不是只给一句泛泛评价。
`review` 不是终点，它要为下一步 `revise` 提供明确输入。

## 使用前必读

开始复核前，至少读取以下文件：
- `templates/<template>/outline.md`
- `templates/<template>/writing-playbook.md`
- `templates/<template>/table-catalog.md`
- `templates/<template>/figure-catalog.md`
- `workspace/plan/progress.md`
- 已生成的 `workspace/outputs/`、`workspace/tables/`、`workspace/figures/` 对应文件

如果 `workspace/assembled/<template>/<template>-formal-draft.md` 已存在，复核时也必须读取它，并把它视为“当前对外版本”。
不要只根据旧 review、旧装配说明或记忆中的字节数下结论。
若本轮 review 是由 `official-doc-assemble` 触发的 final review，应以 `formal-draft` 为主检查对象，而不是只看散件文件。

若 `workspace/plan/project-overview.md` 或 `workspace/plan/progress.md` 中记录了目标总字数，本轮 review 还必须检查：
- 当前稿件总字数是否落在用户要求范围内
- 若未落在范围内，是否已在 Must Fix / Should Fix 中明确记录

## 统计口径（强制统一）

凡涉及章节比例、总字数、`【待补】` 数、final review 结论时，必须统一使用以下统计口径：

### 正文字数统计

- 以当前检查对象为准：
  - 普通 review：优先统计 `workspace/outputs/` 散件正文
  - final review：必须统计 `workspace/assembled/<template>/<template>-formal-draft.md`
- 以下内容不计入“正文总字数”：
  - Markdown 表格单元格
  - Mermaid 代码块
  - 以 `>` 开头的装配引用提示行
  - 仅用于引图引表的标题提示行
  - notes / assembly-notes / review 文本
- 章节比例的分母必须是“同一统计口径下的全部正文字数”，不得混入表格、Mermaid、notes

### `【待补】` 统计

- 默认同时给出两种口径：
  - `标记数`：字面出现了多少次 `【待补】`
  - `字段数`：有多少个待补字段 / 行 / 单元格组
- 若只写一个数字，必须明确标注是“标记数”还是“字段数”
- final review 与 assembly-notes 必须使用同一种口径，不得一个按字段数、一个按标记数

如果当前模板是 `zs-feasibility-report`，还要特别对照：
- 第2章、第3章、第6章是否为正文重心
- 第3章是否已经展开到子课题 / 子任务级别
- 第7章到第9章是否保持“短正文 + 表”为主
- 第3章是否达到正文主量级，而不是只比第4章略长
- 图1是否优先采用子课题树状结构，而不是通用流水线

如果当前模板是 `full-research-template`，还要特别对照：
- 当前是否确实按“单章推进”执行，而不是默认跨多章并写
- 第2章是否为全书最重章节
- 第1章和第4章是否明显重于第3章、第5章、第6章
- 第7章是否结构完整但明显轻于第2章
- 第3章、第5章、第6章是否保持偏短
- 第5章是否已形成资金类主表
- 是否存在已知单位、成员、任务、资金口径在正式稿中被回退成 `【待补】`

## 检查维度

### 1. 标题完整性
- 一级标题是否齐全
- 二级标题是否遗漏
- 是否擅自改写模板固定标题
- 编号顺序是否连续

### 2. 图表一致性
- 图号、表号是否连续
- caption 是否与目录一致
- 正文是否正确引用图表
- 图表内容是否与正文口径一致
- 已装配进正式稿的表图内容，是否与 `workspace/tables/`、`workspace/figures/` 中最新文件一致

### 3. 事实一致性
- 项目名称是否统一
- 单位全称/简称是否统一
- 负责人、成员、职责是否冲突
- 起止时间和阶段计划是否冲突
- 成果数量、预算口径是否冲突

### 4. 风险项
- 是否存在大量 `【待补】`
- 是否存在明显空话套话
- 是否存在“图表已有但正文未引用”
- 是否存在“正文提到表图但文件未生成”
- 是否存在“散件文件已有明确值，但正式稿回退成 `【待补】`”
- 是否存在“review / assembly notes 中的统计口径明显滞后于当前文件”

### 5. 章节配比
- 重章节是否写得足够厚，轻章节是否被写得过长
- 是否出现“应该展开的章节只有骨架，应该简写的章节反而堆叠大段正文”
- 是否存在章节内部层级失衡，例如 ZS 第3章没有下钻到子课题级别

### 6. 高优先表图完备性
- 是否已生成 `table-catalog.md` / `figure-catalog.md` 中标记为“必出”或“高优先”的表图
- 是否按主 skill 约定顺序完成高优先表图
- 是否存在“正文已稳定但高优先表图还没补”

### 7. 装配就绪度
- 当前产物是否已经达到 `review -> revise -> assemble` 的装配前状态
- 是否仍有 Must Fix 会阻断正式装配
- 是否仍缺少支撑重章节的关键表图
- 若用户给出了总字数要求，当前成稿是否满足总字数约束

## 模板专项判定

### ZS-项目可行性报告

必须专项检查：
- 第4章是否已经稳定输出 `图1` 与 `表1`
- 第5章是否已有 `表2`
- 第7章是否已有 `表3`、`表4`
- 第8章是否已有 `表5`
- 第9章是否已有 `表6`
- 第3章是否为全稿最重章节
- 第4章正文是否明显短于第2章、第3章、第6章
- 第7章到第9章正文是否各自明显短于第2章、第3章、第6章
- 图1是否与第3章子课题 1 / 2 / 3 的结构相匹配
- 正式总稿中是否出现过多 `【待补】`

若上述任一高优先表图缺失，默认记入 Must Fix，而不是只记为建议项。

默认验收阈值：
- 第1章正文建议达到正文总量的 `6%` 至 `12%`
- 第3章正文应达到正文总量的 `40%` 至 `50%`
- 第5章正文建议达到正文总量的 `5%` 至 `10%`
- 第4章正文默认不应超过正文总量的 `8%`
- 第7章、第8章、第9章正文默认各自不应超过正文总量的 `4%`
- 正式总稿中 `【待补】` 若超过 `6` 处，应至少记入 Should Fix；若集中出现在正文或表6关键列，应记入 Must Fix
- 若图1改成通用 pipeline 且无说明，默认记入 Should Fix；若导致与第3章结构明显脱节，记入 Must Fix
- 若正式稿中的表格 / 图示内容与 `workspace/tables/`、`workspace/figures/` 的最新文件不一致，默认记入 Must Fix
- 若 review 或 assembly notes 继续引用已经过期的章节字数、比例或结论，默认记入 Must Fix
- 若用户给出总字数硬约束且当前稿件明显超出/低于目标范围，默认至少记入 Should Fix；若偏差过大导致章节结构失真，记入 Must Fix

若本次是装配后 final review，对 ZS 还必须执行以下硬阻断：
- 第3章正文 `< 40%`：直接记入 Must Fix，不得通过 final review
- 第4章正文 `> 8%`：直接记入 Must Fix，不得通过 final review
- 第7章正文 `> 4%`：直接记入 Must Fix，不得通过 final review
- 若第8章或第9章正文 `> 4%`：直接记入 Must Fix，不得通过 final review

### 完整科研项目模板

必须专项检查：
- 是否错误写回旧的“项目单位基本情况”“项目团队工作基础”“联合体成员单位任务分工情况”
- 是否在未获用户明确要求时默认跨两章或多章连续生成
- 第2章稳定后是否已有目标 / 任务 / 路线 / 平台类高优先图表
- 第3章稳定后是否已有任务类高优先表
- 第5章稳定后是否已有资金结构、年度投资、主要投资估算类表
- 第2章是否达到全书最重章节的地位
- 第1章是否保持次重章节地位
- 第4章是否结构完整但未压过第2章
- 第3章、第5章、第6章是否被误写成厚章节
- 第7章是否按风险类别展开且未挤压第2章
- 正式稿中是否把已知单位、成员、任务、资金来源、投资口径回退成 `【待补】`

若第2章、第3章、第5章正文已经成形，但对应高优先表图仍缺失，默认记入 Must Fix。

默认验收阈值：
- 第2章正文应达到正文总量的 `40%` 至 `55%`
- 第1章正文建议达到正文总量的 `12%` 至 `20%`
- 第4章正文建议达到正文总量的 `8%` 至 `16%`
- 第3章正文建议达到正文总量的 `4%` 至 `10%`
- 第5章正文建议控制在正文总量的 `4%` 至 `8%`
- 第6章正文建议控制在正文总量的 `2%` 至 `6%`
- 第7章正文建议控制在正文总量的 `6%` 至 `12%`
- 若正式稿中已知单位、成员、任务、投资口径被回退成 `【待补】`，默认记入 Must Fix
- 若用户给出总字数硬约束且当前稿件明显超出/低于目标范围，默认至少记入 Should Fix；若偏差过大导致章节结构失真，记入 Must Fix

对于章节级 review，默认检查对象应是“当前章节 + 该章必要表图”，不要因为全书尚未写完就把阶段稿误判为失败。
对于全书总 review 或 final review，才按整本比例与装配就绪度做总判定。

## 输出格式

输出到：
- `workspace/review/<template>-review.md`

若本次是由 `official-doc-assemble` 触发的装配后 final review，还必须额外输出：
- `workspace/review/<template>-final-review.md`

建议结构：
0. 统计依据与复核时间
1. 已通过项
2. 必修问题（Must Fix）
3. 可优化问题（Should Fix）
4. 章节配比结论
5. 高优先表图完备性结论
6. 建议修复顺序
7. 仍需补充材料清单
8. 当前是否允许进入 assemble

每个问题尽量写明：
- 严重级别
- 对应文件
- 对应章节 / 表图编号
- 修复动作

“统计依据与复核时间”至少说明：
- 本次统计基于哪些文件
- 是否包含当前 `formal-draft`
- 正文章节比例是按哪一版文件实时计算得出
- 若是装配后 final review，必须明确写出“本次为装配后 final review”
- 若用户给出了总字数要求，必须写出“目标总字数 / 当前统计总字数 / 偏差”
- 必须明确写出“本次正文字数统计是否排除了表格、Mermaid、引用提示行”
- 必须明确写出“`【待补】` 本次采用的是字段数还是标记数”

若本次是装配后 final review：
- `workspace/review/<template>-final-review.md` 必须明确写出“本次为装配后 final review”
- 不要只复用旧的 `workspace/review/<template>-review.md` 而不生成新的 final review 文件

Must Fix 问题应尽量写成：
- `问题`
- `影响文件`
- `修复动作`
- `完成判定`

## 表达要求

问题必须写到可执行，不要只写抽象判断。

例如：
- 不写：`预算有问题`
- 要写：`第9章预算说明中的总预算为120万元，而表6合计为110万元，建议先统一总预算口径，再修订分项。`

对于“章节配比”问题，不要只写“第4章偏短”，要写成类似：
- `第4章“建设方案”只有2个短节，未承接模板要求的任务拆解和路线展开；建议先补齐4.2~4.4三个子节，再回填图4-1、图4-2。`

对于“高优先表图缺失”问题，不要只写“缺表”，要写成类似：
- `第5章资金筹措及投资估算正文已写到投资结构，但 workspace/tables/ 中仍未生成资金结构表；应先调用 official-doc-table 生成该表，再统一第5章正文引用。`

对于“正式稿与散件不一致”问题，要写成类似：
- `workspace/assembled/.../formal-draft.md 中的表2仍为大量【待补】版本，但 workspace/tables/.../table-02.md 已包含具体成员名单；应停止在 assemble 阶段重写表2，改为直接纳入最新 table-02.md。`

对于“风格”问题，不要只写“语言略夸张”，要写成类似：
- `第10章出现“无懈可击”“一举破解”等明显宣传化词语，与原模板的可研文风不一致；建议改回工程说明句和判断句。`

## 交付后动作

- 更新 `workspace/plan/progress.md`
- 若发现大量共性问题，回写 `workspace/plan/facts-ledger.md` 或 `workspace/plan/source-materials.md`
- 若存在可修复问题，默认下一步应调用 `official-doc-revise`
- 若判断“不可装配”，必须明确写出阻断装配的 Must Fix 列表
- 若本次是装配后 final review，必须明确写出：当前 `formal-draft` 是否仍可保留为正式稿，还是需要回退到 `revise -> assemble`
