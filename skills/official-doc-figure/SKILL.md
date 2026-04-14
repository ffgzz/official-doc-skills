---
name: official-doc-figure
description: Use when the current official-document workflow explicitly or implicitly needs figures for ZS-项目可行性报告 or 完整科研项目模板 - generates caption-aligned diagrams and figure notes without requiring the user to ask separately
allowed-tools: Read Write Edit Bash
---

# 公文图示 Skill

## 适用时机

以下任一情况出现时，应主动使用本 Skill：
- 用户明确说要补图
- 当前正文已出现图示引用位
- 技术路线、组织架构、任务分解、进度安排等逻辑更适合图示表达
- 入口 Skill 或主 Skill 判断当前下一步最合理的是补图

## 核心目标

把需要单独表达的结构化逻辑生成为：
- Mermaid 图源
- 图示说明稿
- 必要时的 SVG 说明规范

本 Skill 必须以 `templates/<template>/figure-catalog.md` 为主驱动，而不是临时凭感觉决定先画哪张图。

## 使用前必做

1. 确认当前模板是 `zs-feasibility-report` 还是 `full-research-template`
2. 读取对应 `figure-catalog.md`
3. 识别 catalog 中的优先级、所属章节和推荐节点
4. 核对正文里该图的引用位置和术语
5. 核对相关章节是否已经形成稳定主逻辑

## 选择逻辑

### 先决定“补哪张图”

默认按以下顺序判断：
1. catalog 中标为“必出”或“高优先”的图
2. 当前正文已出现引用位的图
3. 当前最重章节所需要的图
4. 用户明确点名要求的图

### 再决定“画到什么层级”

默认按 catalog 中给出的信息来定：
- 所属章节
- 作用
- 推荐节点
- 正文配套关系
- 扩展与否

不要跳过 catalog 中的节点建议，直接凭空画一张泛化流程图。

## 输出格式

- `figures/<template>/<figure-file>.mmd`
- `figures/<template>/<figure-file>.md`
- 可选：`figures/<template>/<figure-file>-svg-spec.md`

## 强制规则

- 图名 caption 与模板目录一致
- 节点名称与正文术语一致
- 一张图只表达一个主逻辑
- 没有精确数据时，不伪造数值型图表
- 图示说明稿要解释“这张图回答什么问题”
- 必须优先服从 catalog 中的“位置、作用、推荐节点、正文配套”
- 更新 `plan/progress.md`

## ZS-项目可行性报告优先图示

- 图1 技术路线图为固定必出图
- 它必须服务第4章 `（一）项目技术路线`
- 推荐节点以 catalog 为准：输入材料/源数据 → 中间结构建模 → 规则或算法处理 → 内容生成 → 一致性校核 → 人工复核 → 交付输出
- 图1必须与表1形成“路线 + 任务”的配对关系，不要用图1替代表1

## 完整科研项目模板优先图示

第一轮优先图默认包括：
- 图3-2 项目组织架构图
- 图4-1 项目建设总体目标概念图
- 图4-2 项目主要建设任务分解
- 图4-5 项目整体技术路线图
- 关键系统平台架构图

中优先图仅在正文已经形成稳定内容时再补：
- 一般性功能模块图
- 产业链/软件体系版图示意
- 主要单位组织架构图
- 联合体产业链分布图
- 工程应用场景图

扩展专题图仅在第4章已经下钻到专题层级时再补：
- 子任务建设路线图
- 业务流程图 / 送审流程图 / 退审流程图
- 数据模型 / 知识图谱 / 一致性维护技术路线图
- 测试验证流程图 / 测试平台架构图

## 图示说明稿要求

每个 `.md` 说明稿建议至少包含：
1. 图 caption 与所属章节
2. catalog 规定的优先级和用途
3. 这张图回答的核心问题
4. 节点流转说明
5. 与正文的对应关系
6. 装配提示

## 与章节配比的关系

- 对 ZS，图示主要服务第4章，不向第7章到第9章扩散
- 对大模板，图示优先服务第4章，其次才是第3章和第1章
- 偏短章节默认不靠增加图示来“凑厚度”

## 交付前检查

- 图名与正文引用一致
- 节点顺序与正文逻辑一致
- 没有正文中不存在的陌生阶段
- 已遵守 catalog 中的优先级与节点建议
