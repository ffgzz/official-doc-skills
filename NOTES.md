# 设计备注

## 当前设计

插件已从“按公文模板拆分”改为“按共性章节能力拆分”。

当前主链路为：
- `using-official-docs`：解析用户提示词、初始化项目工作区、统筹推进
- `official-doc-core`：通用规则与事实纪律
- 五个共性章节 skill：负责背景、研究内容、创新点、技术成果、技术指标
- `official-doc-table` / `official-doc-figure` / `official-doc-review` / `official-doc-revise` / `official-doc-assemble`：负责公共流程

## 为什么这样改

不同公文模板不同，但很多正式项目材料都会重复出现以下章节能力：
- 项目背景
- 研究内容
- 创新点
- 主要技术成果
- 主要技术指标

把这些能力拆出来后：
- 可以跨不同公文复用
- 不再依赖固定模板目录
- 更适合“主题 + 章节要求 + 表图要求 + 字数要求”的提示词输入方式
