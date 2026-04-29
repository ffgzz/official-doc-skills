# 设计备注

## 当前设计

仓库默认架构已改为“章节 Prompt 模板驱动”：

- `README.md`：唯一说明入口
- `writing-rules/`：通用规则和章节规则，替代旧 skill 的隐式写法约束
- `chapter-prompts/`：章节级 Prompt 模板
- `reference-materials/<project-slug>/`：输入材料
- `generated-drafts/<project-slug>/`：正式输出
- `scripts/init_generation_tree.ps1`：镜像初始化输出目录
- `scripts/assemble_generated_markdown.ps1`：按模板顺序装配整稿

## 为什么这样改

旧流程依赖超长 Prompt 和 skill 总调度，存在三个问题：

- 上下文太长，模型容易偷懒或漏写
- 调度链复杂，不利于局部重跑和局部补写
- 第四章这类重章节特别容易失真

改成章节模板后：

- 模型一次只处理一个章节或一个子章节
- 固定骨架和可写内容边界更清晰
- 旧 skill 里的文风、句式、步骤和样例约束可以显式落盘到 `writing-rules/`
- 第四章可拆分为多个独立文件，减少单轮上下文压力
- 输出目录与模板目录同构，更容易逐章复查、替换和装配

## Legacy 保留策略

以下内容保留但不再作为默认入口：

- `.claude/skills/`
- `workspace/`
- `plan-template/`
- `scripts/init_workspace.ps1`
- `prompt.txt`
- `prompt2.md`
- `prompt3.txt`

仅当需要兼容历史任务或回看旧产物时才使用它们。
