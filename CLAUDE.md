# CLAUDE.md

## 默认入口

- 默认新任务不再从 `.claude/skills/` 启动。
- 处理正式公文时，先读根目录 `README.md`，再按 `writing-rules/ -> chapter-prompts/ -> reference-materials/<project-slug>/ -> generated-drafts/<project-slug>/` 工作。
- `产业链项目指南/完整科研项目模板.docx` 是唯一一级章结构基准。
- 第四章 `项目建设方案` 必须按 `chapter-prompts/ch04-项目建设方案/` 的拆分结构执行。
- 所有回答使用中文。

## 当前主流程

1. 读取 `README.md`
2. 确定 `project-slug`
3. 将资料放入 `reference-materials/<project-slug>/`
4. 运行 `scripts/init_generation_tree.ps1 -ProjectSlug <project-slug>`
5. 先读取通用 `writing-rules/00-03` 和目标章节对应的章节规则
6. 再读取目标章节对应的 Prompt 模板
7. 将正式正文写入 `generated-drafts/<project-slug>/` 同路径文件
8. 需要整稿时，运行 `scripts/assemble_generated_markdown.ps1 -ProjectSlug <project-slug>`

## writing-rules

- `<fixed>`、`<write>`、`<research>` 只允许存在于 `chapter-prompts/` 模板文件中。
- `writing-rules/` 负责文风、句式、论证顺序和深度门槛；`chapter-prompts/` 负责结构、输出路径和章节任务边界。
- 正式输出不得保留任何 XML 标签。
- 不得改章名、编号和计划外节次。
- 若固定结构中出现“按实际单位展开”“按项目实际命名”等表达，表示槽位必须保留，但标题文本和条目数量需依据资料落地。
- 资料不足时可以保留“待补充”，不得编造金额、周期、团队、指标和验收口径。

## Legacy

- `.claude/skills/` 为 legacy 方案，只用于兼容历史 `workspace/` 任务或回看旧流程。
- `workspace/`、`plan-template/`、`scripts/init_workspace.ps1`、`prompt.txt`、`prompt2.md`、`prompt3.txt` 都属于 legacy 资产。
- 若用户明确要求处理历史 skill 产物，再进入 legacy 目录；否则默认不要回到旧流程。
