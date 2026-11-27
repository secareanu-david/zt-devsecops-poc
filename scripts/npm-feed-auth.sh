#!/usr/bin/env bash
# Writes short-lived Azure Artifacts credentials to ~/.npmrc
set -euo pipefail
: "${ADO_ORG:?}" "${ADO_PROJECT:?}" "${ADO_FEED:?}"
if [ -n "${ADO_PAT:-}" ]; then
  TOKEN="$ADO_PAT"
else
  TOKEN=$(az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken -o tsv)
fi
B64=$(printf '%s' "$TOKEN" | base64 -w0)
[ -n "${GITHUB_ACTIONS:-}" ] && echo "::add-mask::${B64}"
BASE="//pkgs.dev.azure.com/${ADO_ORG}/${ADO_PROJECT}/_packaging/${ADO_FEED}/npm"
umask 077
{
  for p in "${BASE}/registry/" "${BASE}/"; do
    echo "${p}:username=ado"
    echo "${p}:_password=${B64}"
    echo "${p}:email=npm@example.com"
  done
} > "$HOME/.npmrc"
echo "Feed credentials written"
