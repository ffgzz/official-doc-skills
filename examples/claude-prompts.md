# Claude Code 测试提示词（Plugin 模式）

> 默认插件名：`official-doc-writing-skill`

## 1. 启动 ZS-项目可行性报告流程

```text
/official-doc-writing-skill:using-official-docs
当前任务：ZS-项目可行性报告。
输入材料：materials/test-case-zs/
参考样稿：materials/reference/ZS-项目可行性报告.docx，仅参考结构和风格，不照抄内容。
请完成：
1. 判定模板
2. 初始化 plan/、outputs/、tables/、figures/、review/
3. 读取模板 outline / source-checklist / table-catalog / figure-catalog
4. 生成工作区骨架和正文初稿
```

## 2. 只跑 ZS 正文主 Skill

```text
/official-doc-writing-skill:zs-feasibility-report
请基于 materials/test-case-zs/ 生成一份新的 ZS-项目可行性报告初稿。
参考 materials/reference/ZS-项目可行性报告.docx 的结构和风格，但不要照抄内容。
输出到 outputs/zs-feasibility-report-test/。
```

## 3. 补表格

```text
/official-doc-writing-skill:official-doc-table
请为当前 ZS 测试稿生成表1、表2、表5、表6，输出到 tables/zs-feasibility-report-test/。
所有未知字段标注【待补】。
```

## 4. 补图示

```text
/official-doc-writing-skill:official-doc-figure
请为当前 ZS 测试稿生成图1 技术路线图，输出到 figures/zs-feasibility-report-test/。
图示逻辑建议采用：数据采集与清洗 → 中间结构建模 → 模板映射 → 报告生成 → 一致性校核 → 人工复核 → 导出交付。
```

## 5. 最终复核

```text
/official-doc-writing-skill:official-doc-review
请对当前 ZS 测试稿做总复核，检查标题、图表编号、项目名称、预算口径和所有【待补】项，输出到 review/zs-feasibility-report-test-review.md。
```

## 6. 启动完整科研项目模板流程

```text
/official-doc-writing-skill:using-official-docs
当前任务：完整科研项目模板。
输入材料：materials/test-case-full/
请不要整本一口气写完，只需：
1. 初始化工作区
2. 读取 outline / source-checklist / chapter-splitting-plan / table-catalog / figure-catalog
3. 生成一级章节骨架和分阶段执行计划
```
