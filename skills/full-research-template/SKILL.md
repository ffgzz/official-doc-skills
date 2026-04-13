---
name: full-research-template
description: Use when the task is to write, continue, revise, or complete the 完整科研项目模板 from user-provided materials - handles the large built-in template, writes in phased chapter batches, and proactively routes to tables, figures, and review
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

### 结构风格
- 先稳骨架，再下钻章节
- 优先保证主逻辑章节成立，而不是追求整本同时铺满
- 对金额、效益、投资类章节，先写测算逻辑和口径，再填具体数据

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

### 第 3 阶段：组织与基础支撑
继续写：
- 项目单位基本情况
- 项目团队工作基础
- 项目组织及实施管理

### 第 4 阶段：任务与财务效益
继续写：
- 项目任务设置
- 联合体成员单位任务分工情况
- 财务经济效益测算

### 第 5 阶段：表图与总复核
在正文骨架和主要章节成型后，主动推进：
- 高频表格
- 技术路线图/组织架构图/任务分解图
- 全书一致性复核

## 六、各类章节的写法要求

### 项目背景及必要性
必须讲清：
- 为什么现在必须做
- 行业痛点与现实约束是什么
- 本项目对产业链、能力建设、应用场景有什么必要性

### 项目建设方案
这是全书核心章。
必须尽量讲清：
- 总体目标
- 建设任务体系
- 技术路线
- 预期成果
- 工程验证思路

### 资金筹措及投资估算
若金额不充分，先写：
- 测算逻辑
- 资金来源构成
- 估算口径
- 约束条件

具体数字不足时写 `【待补】`。

### 财务经济效益测算
不要臆造财务收益数字。
可以先写：
- 测算思路
- 适用假设
- 关键影响因素
- 需要补充的数据清单

### 项目综合风险因素分析
每类风险都要对应：
- 风险来源
- 对项目的影响
- 缓释或应对措施

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

### 主动调用 `official-doc-figure`
当出现以下任一情况时：
- 项目建设方案已形成较稳定的主逻辑，可生成技术路线图
- 组织及实施管理已形成清晰层级，可生成组织架构图
- 项目任务设置已形成任务树，可生成任务分解图

### 主动调用 `official-doc-review`
当出现以下任一情况时：
- 当前阶段已形成一批正文和表图
- 用户要求检查、复核、体检
- 你准备说明“本轮阶段性完成”

## 九、不要做的事

- 不要整本一口气写完却不落文件
- 不要没有依据就补单位能力、财务收益、投资金额
- 不要把所有图表内容硬写成文字替代
- 不要跳过 `chapter-splitting-plan.md` 的分阶段思想
