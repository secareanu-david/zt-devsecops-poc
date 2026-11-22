#!/usr/bin/env bash
set -euo pipefail
echo "== Secure Score $(date -u +%FT%TZ)"
az security secure-scores list \
  --query "[].{score:displayName, current:score.current, max:score.max, percent:score.percentage}" -o table
echo "== Defender assessments for rg-zt-app"
az security assessment list --only-show-errors -o json | jq -r '
  .[] | select(.id | ascii_downcase | contains("rg-zt-app"))
      | [.status.code, .displayName] | @tsv' | sort
