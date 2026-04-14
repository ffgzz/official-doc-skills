---
name: official-doc-revise
description: Use after review for ZS-项目可行性报告 or 完整科研项目模板 - fixes review findings in body chapters, tables, figures, and ledgers without inventing facts, then prepares the draft for assembly
allowed-tools: Read Write Edit Bash
---

# 公文回修 Skill

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- `official-doc-review` 已经产出问题清单
- 用户要求“修改”“回修”“按复核意见调整”
- 你准备装配正式总稿，但当前草稿仍存在标题、口径、表图引用或格式问题

## 核心目标

依据 `review/<template>-review.md` 的问题清单，定向修复正文、表格、图示和台账中的问题。
本 Skill 解决的是“把诊断结果落实到文件”，不是重新写一份新稿。

## 使用前必读

开始回修前，至少读取以下文件：
- `review/<template>-review.md`
- `templates/<template>/outline.md`
- `templates/<template>/writing-playbook.md`
- `templates/<template>/table-catalog.md`
- `templates/<template>/figure-catalog.md`
- `plan/facts-ledger.md`
- 当前受影响的 `outputs/`、`tables/`、`figures/` 文件

## 使用前必做

1. 读取对应 `review/<template>-review.md`
2. 按严重级别区分 Must Fix / Should Fix
3. 逐项定位受影响文件
4. 核对 `plan/facts-ledger.md` 中相关事实口径

## 强制规则

- 优先修复 Must Fix，再处理 Should Fix
- 不得绕过 review 清单直接大改全文
- 不得为了“修完”而补造事实
- 无法确认的事实继续保留 `【待补】`
- 修订后要同步更新 `plan/progress.md`
- 若 Must Fix 包含高优先表图缺失，必须优先补表 / 补图，再回修正文引用
- 若 Must Fix 包含章节配比失衡，必须优先修正章节展开深度，再处理措辞润色

## 回修顺序

默认按以下顺序推进：
1. 修标题、编号、固定模板结构错误
2. 修章节配比问题
3. 补高优先表图缺失
4. 修正文与表图引用、术语、数字口径
5. 修台账与进度记录

不要一上来就只改文字表述，先解决结构性问题。

## 典型修订动作

- 标题与编号修订
- 正文与表图引用统一
- 项目名称、单位、负责人、周期、预算等口径统一
- 将 review 指出的空泛段落改成更贴近模板要求的正式表述
- 将缺失说明补回台账，而不是只在对话中说明

## 模板专项回修要求

### ZS-项目可行性报告

若 review 指出以下问题，应按此顺序修：
1. 第3章未展开到子课题 / 子任务级别：先补正文层级
2. 第4章未形成 `图1 + 表1`：先补 `图1`，再补 `表1`
3. 第7章到第9章正文过长：压缩正文，恢复“短正文 + 表”结构
4. `表2` 到 `表6` 缺失：按第5章、第7章、第8章、第9章顺序补齐

### 完整科研项目模板

若 review 指出以下问题，应按此顺序修：
1. 第4章偏薄：优先补建设方案正文，再补第4章高优先图表
2. 第3章团队类支撑不足：先补团队类高优先表，再统一正文引用
3. 第8章资金口径缺支撑：先补资金结构、年度投资、主要投资估算类表
4. 第5章、第6章、第8章、第9章过长：压缩为“结论 + 关键表”结构，不扩写成长章

## 与 table / figure skill 的协同

如果 review 明确指出某个高优先表图缺失，不要只在 review 文件里标记“待补”：
- 缺高优先表时，应主动调用 `official-doc-table`
- 缺高优先图时，应主动调用 `official-doc-figure`
- 表图补齐后，必须回修正文中的引用句、编号和说明文字

`revise` 的职责不是回避补件，而是把 review 发现的问题真正落到文件上。

## 交付要求

至少说明：
- 已修复哪些问题
- 哪些问题因材料缺失仍保留 `【待补】`
- 当前是否可以进入 `official-doc-assemble`

如果仍不能进入 `official-doc-assemble`，要明确列出剩余阻断项：
- 未修复的 Must Fix
- 未补齐的高优先表图
- 仍失衡的重章节 / 轻章节

## 交付后动作

- 更新 `plan/progress.md`
- 若 Must Fix 已处理完，默认下一步进入 `official-doc-assemble`
