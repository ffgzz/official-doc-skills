#!/usr/bin/env bash
set -euo pipefail

TEMPLATE="${1:-zs-feasibility-report}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

mkdir -p \
  "${PLUGIN_ROOT}/plan" \
  "${PLUGIN_ROOT}/outputs/${TEMPLATE}" \
  "${PLUGIN_ROOT}/tables/${TEMPLATE}" \
  "${PLUGIN_ROOT}/figures/${TEMPLATE}" \
  "${PLUGIN_ROOT}/assembled/${TEMPLATE}" \
  "${PLUGIN_ROOT}/review"
for f in project-overview.md source-materials.md facts-ledger.md progress.md; do
  if [ ! -f "${PLUGIN_ROOT}/plan/${f}" ]; then
    cp "${PLUGIN_ROOT}/plan-template/${f}" "${PLUGIN_ROOT}/plan/${f}"
  fi
done

echo "Workspace initialized for ${TEMPLATE}"
