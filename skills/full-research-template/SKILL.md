---
name: full-research-template
description: Use when the task is to write, continue, revise, or complete the 完整科研项目模板 from user-provided materials - handles the large built-in template, writes in phased chapter batches, and proactively routes to tables, figures, review, revise, and assembly
allowed-tools: Read Write Edit Bash
---

# 完整科研项目模板主 Skill

这是 `完整科研项目模板` 的定制化主 Skill。

它的目标不是一轮吐出整本，而是让用户只需说明：
- 要写 完整科研项目模板
- 材料在哪里

然后由你自动完成：
- 套用大模板骨架
- 初始化输出目录和台账
- 按章节批次推进正文
- 在合适阶段主动补表、补图、做复核

## 一、不要再向用户默认追问参考样稿

本 Skill 的结构和推进方式优先来自：
- `templates/full-research-template/outline.md`
- `templates/full-research-template/writing-playbook.md`
- `templates/full-research-template/chapter-splitting-plan.md`
- `templates/full-research-template/table-catalog.md`
- `templates/full-research-template/figure-catalog.md`
- `official-doc-core`

默认不向用户追问样稿来决定这份大模板的结构和风格。

## 二、模板特点

这不是轻量文书，而是大体量项目模板，典型特征是：
- 标题层级深
- 图表密度高
- 单位与联合体信息多
- 经费、投资、效益口径复杂
- 各章之间相互依赖

因此必须采用“分阶段推进”，不能一口气整本硬写。

## 三、内建结构（一级章）

按当前模板，至少要围绕以下一级章推进：

1. 项目背景及必要性
2. 项目单位基本情况
3. 项目团队工作基础
4. 项目建设方案
5. 项目任务设置
6. 联合体成员单位任务分工情况
7. 项目组织及实施管理
8. 资金筹措及投资估算
9. 财务经济效益测算
10. 项目综合风险因素分析

二级标题以 `templates/full-research-template/outline.md` 为准。

## 四、默认写作风格

### 格式刚性
- 必须遵守 `templates/full-research-template/outline.md` 及对应模板的大章节轻重关系
- 第4章 `项目建设方案` 是全书最重章节
- 第1章、第2章、第3章是前半本重章节，应明显重于第5章、第6章、第8章、第9章
- 第5章、第6章、第8章、第9章默认偏短，重在结构和口径，不追求长篇铺陈
- 第10章需按风险类别成组展开，但不应压过第4章

### 结构风格
- 先稳骨架，再下钻章节
- 优先保证主逻辑章节成立，而不是追求整本同时铺满
- 对金额、效益、投资类章节，先写测算逻辑和口径，再填具体数据
- 保留“前重后轻、建设方案最重、任务和财务偏短”的真实模板节奏

### 语言风格
- 申报/论证口径
- 组织化、说明化、工程化
- 不写宣传稿式语言
- 不把待审批事项写成既定事实

## 五、自动执行流程

### 第 1 阶段：搭全书骨架
必须完成：
1. 读取模板文件
2. 建立或复用 `outputs/full-research-template/`
3. 生成 `outputs/full-research-template/01-outline.md`
4. 生成分阶段执行计划
5. 更新 `plan/project-overview.md`
6. 更新 `plan/source-materials.md`
7. 更新 `plan/facts-ledger.md`
8. 更新 `plan/progress.md`

### 第 2 阶段：主逻辑章节
优先写：
- 项目背景及必要性
- 项目建设方案
- 资金筹措及投资估算
- 项目综合风险因素分析

原因：这四章决定整本模板的可信度、主线和论证力度。

其中必须注意：
- 第1章要完整，不能压缩成薄背景
- 第4章必须深层级展开，是全书绝对重心
- 第8章先写资金结构与估算逻辑，不急于臆造明细
- 第10章按风险类别逐项写清风险与对策

### 第 3 阶段：组织与基础支撑
继续写：
- 项目单位基本情况
- 项目团队工作基础
- 项目组织及实施管理

其中必须注意：
- 第2章、第3章通常是多单位并列展开的重章节
- 写法应同构、分项、可比较
- 第7章结构要清楚，但篇幅不应压过第4章

### 第 4 阶段：任务与财务效益
继续写：
- 项目任务设置
- 联合体成员单位任务分工情况
- 财务经济效益测算

其中必须注意：
- 第5章、第6章偏短，重在任务和分工边界落位
- 第9章偏短，重在假设、逻辑、收益结构，不是长篇政策背景

### 第 5 阶段：表图与总复核
在正文骨架和主要章节成型后，主动推进：
- 高频表格
- 技术路线图/组织架构图/任务分解图
- 全书一致性复核
- 必要回修
- 正式总稿装配

## 六、各类章节的写法要求

### 项目背景及必要性
必须讲清：
- 为什么现在必须做
- 行业痛点与现实约束是什么
- 本项目对产业链、能力建设、应用场景有什么必要性

强制要求：
- 不能只写成背景综述
- 尽量保留“建设背景 / 建设意义 / 国内外现状及前景 / 预期解决重大问题 / 对产业链供应链韧性及安全的意义”这条完整链路
- 这是论证重章节

### 项目建设方案
这是全书核心章。
必须尽量讲清：
- 总体目标
- 建设任务体系
- 技术路线
- 预期成果
- 工程验证思路

强制要求：
- 这一章必须是全书最长章节
- 必须允许深层级下钻，不可只停留在概括性二级标题
- 图示和高频表格应优先服务这一章

### 资金筹措及投资估算
若金额不充分，先写：
- 测算逻辑
- 资金来源构成
- 估算口径
- 约束条件

具体数字不足时写 `【待补】`。

写法要求：
- 本章偏短，先讲逻辑和口径，再落表
- 不要用大量背景段落稀释测算信息

### 财务经济效益测算
不要臆造财务收益数字。
可以先写：
- 测算思路
- 适用假设
- 关键影响因素
- 需要补充的数据清单

写法要求：
- 本章偏短，重点在收益逻辑和假设条件
- 不要扩写成比第2章、第3章还重的长文

### 项目综合风险因素分析
每类风险都要对应：
- 风险来源
- 对项目的影响
- 缓释或应对措施

写法要求：
- 尽量按技术、市场、经营、资金、法律、政策等风险类别成组展开
- 每类风险保持“风险分析 + 应对措施”的对应关系

## 七、正文输出文件

至少维护以下文件：
- `outputs/full-research-template/01-outline.md`
- `outputs/full-research-template/chapter-01-background-necessity.md`
- `outputs/full-research-template/chapter-02-organization-profile.md`
- `outputs/full-research-template/chapter-03-team-foundation.md`
- `outputs/full-research-template/chapter-04-construction-plan.md`
- `outputs/full-research-template/chapter-05-task-setting.md`
- `outputs/full-research-template/chapter-06-consortium-division.md`
- `outputs/full-research-template/chapter-07-organization-management.md`
- `outputs/full-research-template/chapter-08-funding-investment.md`
- `outputs/full-research-template/chapter-09-financial-benefit.md`
- `outputs/full-research-template/chapter-10-risk-analysis.md`

## 八、何时主动调用通用 Skill

### 主动调用 `official-doc-table`
当出现以下任一情况时：
- 当前章节明显需要组织、成员、任务、经费、成果类表格
- 正文中已留出表格引用位
- 用户说“继续推进”，而当前最自然的下一步是补表

默认触发顺序：
1. 第3章稳定后，优先补团队类高优先表：`表3-2`、`表3-3`、`表3-4`
2. 第4章稳定后，优先补成果与任务分配类高优先表：`表4-1`、`表4-2`、`表4-3`、`表4-4`
3. 第8章稳定后，优先补资金与投资测算类高优先表：资金来源结构表、分年度投资安排表、主要投资估算表
4. 中优先和扩展表只有在正文已经下钻到对应层级时再补

### 主动调用 `official-doc-figure`
当出现以下任一情况时：
- 项目建设方案已形成较稳定的主逻辑，可生成技术路线图
- 组织及实施管理已形成清晰层级，可生成组织架构图
- 项目任务设置已形成任务树，可生成任务分解图

默认触发顺序：
1. 第3章稳定后，优先补 `图3-2 项目组织架构图`
2. 第4章稳定后，优先补 `图4-1`、`图4-2`、`图4-5`
3. 第1章或第2章确有强图示需求时，再补功能模块图、体系版图、单位组织图等中优先图
4. 只有当第4章已经下钻到专题层级时，再补扩展专题图

### 主动调用 `official-doc-review`
当出现以下任一情况时：
- 当前阶段已形成一批正文和表图
- 用户要求检查、复核、体检
- 你准备说明“本轮阶段性完成”

默认进入 review 的时点：
- 第3章、第4章、第8章对应的高优先表图至少已补齐一轮
- 不要在高优先表图尚未补齐时过早进入总 review

### 主动调用 `official-doc-revise`
当出现以下任一情况时：
- `official-doc-review` 已产出问题清单
- 章节、表图、口径需要按 review 意见回修

### 主动调用 `official-doc-assemble`
当出现以下任一情况时：
- 当前批次已经 review / revise 完成
- 用户要求正式稿、合稿、交付稿

## 九、不要做的事

- 不要整本一口气写完却不落文件
- 不要没有依据就补单位能力、财务收益、投资金额
- 不要把所有图表内容硬写成文字替代
- 不要跳过 `chapter-splitting-plan.md` 的分阶段思想
- 不要把第5章、第6章、第8章、第9章写成和第4章同量级的长章节
- 不要把第4章写成薄骨架
