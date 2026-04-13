---
name: zs-feasibility-report
description: Use when the task is to write, continue, revise, expand, or complete a ZS-项目可行性报告 from user-provided materials - handles the built-in 10-chapter template, writes the body in phased passes, and proactively hands off tables, figures, and review
allowed-tools: Read Write Edit Bash
---

# ZS-项目可行性报告主 Skill

这是 `ZS-项目可行性报告` 的定制化主 Skill。

它的目标是让用户只需说明：
- 要写 ZS-项目可行性报告
- 材料在哪里

然后由你自动完成：
- 套用固定模板
- 初始化输出目录
- 生成骨架
- 分阶段写正文
- 在需要时主动生成表格、图示并做复核

## 一、不要再向用户默认追问参考样稿

本 Skill 的结构、风格和推进方式，优先来自：
- `templates/zs-feasibility-report/outline.md`
- `templates/zs-feasibility-report/writing-playbook.md`
- `templates/zs-feasibility-report/table-catalog.md`
- `templates/zs-feasibility-report/figure-catalog.md`
- `official-doc-core`

除非用户自己明确提供样稿并要求对齐，否则不要把“需要参考样稿”当作默认前提。

## 二、模板结构（固定）

一级标题固定为以下 10 章：

1. 一、概述
2. 二、项目现状和发展趋势
3. 三、研发内容及技术关键
4. 四、技术路线和实施方案
5. 五、现有工作基础和条件
6. 六、困难评估
7. 七、预期目标
8. 八、计划进度安排
9. 九、经费预算
10. 十、研究结论

二级标题以 `templates/zs-feasibility-report/outline.md` 为准。

## 三、默认写作风格

### 结构风格
- 中等篇幅
- 逻辑主线清晰
- “为什么做 → 现状不足 → 做什么 → 怎么做 → 谁来做 → 目标是什么 → 什么时候做 → 预算如何 → 为什么可行” 这条主线必须完整

### 语言风格
- 申报/可研口径
- 正式、谨慎、可落地
- 不写空泛宣传口号
- 不把预期写成既成事实

### 事实策略
- 没有根据的数字统一写 `【待补】`
- 时间、经费、成果数、成员数不能臆造

## 四、自动执行流程

### 第 1 阶段：初始化与骨架
必须完成：
1. 读取模板文件
2. 建立或复用 `outputs/zs-feasibility-report/`
3. 生成 `outputs/zs-feasibility-report/01-outline.md`
4. 更新 `plan/project-overview.md`
5. 更新 `plan/source-materials.md`
6. 更新 `plan/facts-ledger.md`
7. 更新 `plan/progress.md`

### 第 2 阶段：优先生成正文主干（1～4 章）
优先写：
- 第1章 概述
- 第2章 项目现状和发展趋势
- 第3章 研发内容及技术关键
- 第4章 技术路线和实施方案

原因：这四章决定整份可行性报告的立项逻辑与技术可信度。

### 第 3 阶段：支撑与目标（5～7 章）
继续写：
- 第5章 现有工作基础和条件
- 第6章 困难评估
- 第7章 预期目标

### 第 4 阶段：计划、预算、结论（8～10 章）
继续写：
- 第8章 计划进度安排
- 第9章 经费预算
- 第10章 研究结论

## 五、各章写法要求

### 第1章 概述
必须回答：
- 为什么要做这个项目
- 这个项目要解决什么核心问题
- 项目的总体目标是什么

### 第2章 项目现状和发展趋势
必须回答：
- 当前行业/技术/流程发展到什么程度
- 当前方案还有什么明显不足
- 下一步发展趋势与本项目的关系是什么

### 第3章 研发内容及技术关键
这是核心技术章。
必须尽量写清：
- 研发对象
- 子任务分解
- 每个子任务解决什么问题
- 关键技术与创新点

### 第4章 技术路线和实施方案
这是核心方案章。
正文中必须为以下内容留位：
- `图1 技术路线图`
- `表1 项目任务表`

### 第5章 现有工作基础和条件
正文中必须为以下内容留位：
- `表2 项目主要成员`

### 第7章 预期目标
正文中必须为以下内容留位：
- `表3 项目技术成果`
- `表4 项目预期成效`

### 第8章 计划进度安排
正文中必须为以下内容留位：
- `表5 项目攻关计划进度安排`

### 第9章 经费预算
正文中必须为以下内容留位：
- `表6 经费预算表`

## 六、正文输出文件

至少维护以下文件：
- `outputs/zs-feasibility-report/01-outline.md`
- `outputs/zs-feasibility-report/chapter-01-overview.md`
- `outputs/zs-feasibility-report/chapter-02-status-trend.md`
- `outputs/zs-feasibility-report/chapter-03-rd-content-key-tech.md`
- `outputs/zs-feasibility-report/chapter-04-route-implementation.md`
- `outputs/zs-feasibility-report/chapter-05-foundation-team.md`
- `outputs/zs-feasibility-report/chapter-06-difficulty-assessment.md`
- `outputs/zs-feasibility-report/chapter-07-targets.md`
- `outputs/zs-feasibility-report/chapter-08-schedule.md`
- `outputs/zs-feasibility-report/chapter-09-budget.md`
- `outputs/zs-feasibility-report/chapter-10-conclusion.md`

## 七、何时主动调用通用 Skill

### 主动调用 `official-doc-table`
当出现以下任一情况时：
- 正文中已留出表1～表6引用位
- 当前阶段已写到团队、成果、进度、预算等明显需要表格的章节
- 用户说“继续推进”，而当前缺口正好是表格

### 主动调用 `official-doc-figure`
当出现以下任一情况时：
- 第4章已形成技术链条，可生成 `图1 技术路线图`
- 用户说“继续推进”，而图1仍未生成

### 主动调用 `official-doc-review`
当出现以下任一情况时：
- 一轮正文、表格、图示已基本成型
- 你准备告诉用户“这一轮已完成”
- 用户明确要求检查、复核、体检

## 八、不要做的事

- 不要把 10 章一口气写成一篇长回复却不落文件
- 不要在没依据时补写预算金额
- 不要把表格内容全部揉进正文
- 不要跳过图1和表1～表6的占位与后续衔接
