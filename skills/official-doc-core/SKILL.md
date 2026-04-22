---
name: official-doc-core
description: 项目公文写作的公共校验层。仅在 using-official-docs 完成 brief 解析和工作区初始化后使用，用于检查台账、事实纪律、阶段顺序、章节依赖、正式文风和写作深度门禁。它不创建工作区，不首次写 plan，也不直接联网搜索或写五类共性章节。
allowed-tools: Read Write Edit Bash
---

# 公文写作通用规则

> 当前项目只使用提示词驱动流程。
>
> 当前通用规则是：
> - 以 `project-brief.md` 和 `00-section-plan.md` 为准
> - 工作区按 `workspace/<kind>/<project-slug>/` 隔离
> - 五类共性章节先过 `official-doc-research` 调研门禁、先落账、后写作
> - `创新点` 回指现状差距与研究内容
> - `技术成果` 由研究内容推出
> - `技术指标` 可量化、可测试、可验证

这是当前写作流程的公共门禁层。

涉及正式正文写法时，读取：
- [references/formal-doc-style.md](./references/formal-doc-style.md)
- [references/depth-writing-rules.md](./references/depth-writing-rules.md)
- [references/depth-writing-examples.md](./references/depth-writing-examples.md)

## 一、执行原则

### 1. brief 先于措辞
先服从用户提示词拆出的章节、图表、字数和风格要求，再考虑润色。

### 2. 流程先于提问
当下一步可以根据工作区状态自动判断时，不要把流程分支问题抛回给用户。

### 3. 事实先于完整
材料不够时，不补造信息；用 `【待补】` 显式占位，并同步回写台账。

### 4. 台账先于口头说明
任何缺口、冲突、阻断原因，都要回写到 `workspace/plan/<project-slug>/`，不能只在对话里说。

### 5. 用户字数要求是硬约束
如果用户明确给出总字数、上下限或篇幅要求，必须把它视为硬约束。

### 6. 表图服务正文，不替代正文
适合用表表达的，不硬写成长段；适合用图表达的，不把图的逻辑塞回正文。

### 7. 正文必须像正式公文，不像演示稿或 AI 草稿
正文默认写成连续自然段，不写成项目符号堆砌，不写成加粗小标签拼贴，不写成机械的多级目录摘抄。

### 7.5 正文必须有论证深度
五类共性章节写作前，必须先建立“章节论证链”，至少说明本章核心判断、事实依据、差距问题、技术机制、输出结果和边界条件。若论证链填不实，不得靠空泛扩写凑字数，应回到 `official-doc-research` 补调研，或只向用户提出一个会影响方向的关键问题。

### 8. core 不代替专项 skill
`official-doc-core` 只做公共校验，不代替：
- `official-doc-research`
- `official-doc-project-background`
- `official-doc-research-content`
- `official-doc-innovation`
- `official-doc-technical-achievements`
- `official-doc-technical-indicators`

若当前章节命中上述五类之一，core 执行后下一步必须先进入 `official-doc-research`，再显式加载对应专项 skill，而不是由 core 自己搜索或写作。

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
- 现状
- 痛点
- 必要性
```

正确：

```md
当前，行业数字化和智能化转型正在持续深化，但相关核心环节仍存在数据沉淀不足、流程割裂和经验依赖较强等问题。围绕这些瓶颈，本项目有必要从现状差距、业务痛点和工程需求三个层面展开分析，从而为后续攻关内容提供充分依据。
```

### 标题要求
- 一级标题与用户要求保持一致
- 二级标题优先服从用户指定的小节结构
- 若用户未固定更深层级，可补充三级小标题，但必须服务现有逻辑
- 材料不足时不删标题，只在对应位置补 `【待补】`

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
