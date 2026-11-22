#!/usr/bin/env bash
set -euo pipefail
MODE="${1:-Audit}"
SCOPE=$(az group show -n rg-zt-app --query id -o tsv)

assign() {   # $1 assignment name, $2 built-in display name, $3 optional params JSON
  local def
  def=$(az policy definition list --query "[?displayName=='$2'].name | [0]" -o tsv)
  if [ -z "$def" ]; then echo "Policy not found: $2" >&2; exit 1; fi
  az policy assignment create --name "$1" --display-name "ZT: $2" \
    --policy "$def" --scope "$SCOPE" ${3:+--params "$3"} --output none
  echo "Assigned: $2"
}

EFFECT="{\"effect\":{\"value\":\"$MODE\"}}"

assign zt-app-https   "App Service apps should only be accessible over HTTPS" "$EFFECT"
assign zt-app-tls     "App Service apps should use the latest TLS version"
assign zt-app-ftps    "App Service apps should require FTPS only"
assign zt-st-secure   "Secure transfer to storage accounts should be enabled" "$EFFECT"
assign zt-st-public   "Storage account public access should be disallowed"   "$EFFECT"
