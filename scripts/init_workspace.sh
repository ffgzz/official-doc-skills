#!/usr/bin/env bash
set -euo pipefail

TEMPLATE="${1:-zs-feasibility-report}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_ROOT="${PLUGIN_ROOT}/workspace"

mkdir -p \
  "${WORKSPACE_ROOT}/plan" \
  "${WORKSPACE_ROOT}/outputs/${TEMPLATE}" \
  "${WORKSPACE_ROOT}/tables/${TEMPLATE}" \
  "${WORKSPACE_ROOT}/figures/${TEMPLATE}" \
  "${WORKSPACE_ROOT}/assembled/${TEMPLATE}" \
  "${WORKSPACE_ROOT}/review"
for f in project-overview.md source-materials.md facts-ledger.md progress.md; do
  if [ ! -f "${WORKSPACE_ROOT}/plan/${f}" ]; then
    cp "${PLUGIN_ROOT}/plan-template/${f}" "${WORKSPACE_ROOT}/plan/${f}"
  fi
done

echo "Workspace initialized at ${WORKSPACE_ROOT} for ${TEMPLATE}"
