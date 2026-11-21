#!/usr/bin/env bash
set -euo pipefail
python3 -m venv "$HOME/ansible-venv"
"$HOME/ansible-venv/bin/pip" install --quiet -r infra/requirements.txt
"$HOME/ansible-venv/bin/ansible-galaxy" collection install -r infra/requirements.yml
"$HOME/ansible-venv/bin/pip" install --quiet \
  -r "$HOME/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt"
echo "$HOME/ansible-venv/bin" >> "$GITHUB_PATH"
