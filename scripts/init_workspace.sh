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
for f in project-overview.md project-brief.md research-sources.md facts-ledger.md progress.md; do
  if [ ! -f "${WORKSPACE_ROOT}/plan/${PROJECT_SLUG}/${f}" ]; then
    cp "${PLUGIN_ROOT}/plan-template/${f}" "${WORKSPACE_ROOT}/plan/${PROJECT_SLUG}/${f}"
  fi
done

echo "Workspace initialized at ${WORKSPACE_ROOT} for ${PROJECT_SLUG}"
