#!/usr/bin/env bash
# Rewrites "uses: owner/repo[/path]@vX" to "uses: owner/repo[/path]@<sha> # vX"
set -euo pipefail
for f in .github/workflows/*.yml; do
  grep -oE 'uses: [A-Za-z0-9_.-]+/[A-Za-z0-9_./-]+@v[0-9][A-Za-z0-9_.-]*$' "$f" | sort -u |
  while read -r _ ref; do
    action="${ref%@*}"; tag="${ref#*@}"
    repo=$(echo "$action" | cut -d/ -f1-2)
    sha=$(git ls-remote "https://github.com/$repo" "refs/tags/$tag" "refs/tags/$tag^{}" | tail -n1 | cut -f1)
    if [ -z "$sha" ]; then echo "No SHA found for $ref" >&2; exit 1; fi
    sed -i "s|uses: $action@$tag\$|uses: $action@$sha # $tag|" "$f"
    echo "$ref -> $sha"
  done
done
