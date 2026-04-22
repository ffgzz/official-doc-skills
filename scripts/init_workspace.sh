#!/usr/bin/env bash
set -euo pipefail

PROJECT_SLUG="${1:-current-project}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_ROOT="${PLUGIN_ROOT}/workspace"

mkdir -p \
  "${WORKSPACE_ROOT}/plan/${PROJECT_SLUG}" \
  "${WORKSPACE_ROOT}/outputs/${PROJECT_SLUG}" \
  "${WORKSPACE_ROOT}/tables/${PROJECT_SLUG}" \
  "${WORKSPACE_ROOT}/figures/${PROJECT_SLUG}" \
  "${WORKSPACE_ROOT}/review/${PROJECT_SLUG}" \
  "${WORKSPACE_ROOT}/assembled/${PROJECT_SLUG}"
for f in project-overview.md project-brief.md stage-gates.md research-plan.md research-sources.md research-evidence.md research-notes.md facts-ledger.md progress.md source-materials.md; do
  if [ ! -f "${WORKSPACE_ROOT}/plan/${PROJECT_SLUG}/${f}" ]; then
    cp "${PLUGIN_ROOT}/plan-template/${f}" "${WORKSPACE_ROOT}/plan/${PROJECT_SLUG}/${f}"
  fi
done

SECTION_PLAN="${WORKSPACE_ROOT}/outputs/${PROJECT_SLUG}/00-section-plan.md"
if [ ! -f "${SECTION_PLAN}" ]; then
  cat > "${SECTION_PLAN}" <<'EOF'
# 章节计划

## 全文编号方案

- 目标文体：
- 编号方案：
- 特殊说明：

## 章节拆解

| 章节序号 | 章节标题 | 命中 skill | 编号层级要求 | 当前状态 | 备注 |
|---|---|---|---|---|---|
EOF
fi

echo "Workspace initialized at ${WORKSPACE_ROOT} for ${PROJECT_SLUG}"
