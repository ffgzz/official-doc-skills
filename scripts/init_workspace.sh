\
#!/usr/bin/env bash
set -euo pipefail

TEMPLATE="${1:-zs-feasibility-report}"
mkdir -p "plan" "outputs/${TEMPLATE}" "tables/${TEMPLATE}" "figures/${TEMPLATE}" "review"
for f in project-overview.md source-materials.md facts-ledger.md progress.md; do
  if [ ! -f "plan/${f}" ]; then
    cp "plan-template/${f}" "plan/${f}"
  fi
done

echo "Workspace initialized for ${TEMPLATE}"
