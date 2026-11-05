#!/usr/bin/env bash
# Lock every github: flake input to the newest commit on its tracked branch
# (or default branch) that is at least $AGE old (supply-chain cooldown).
# flake.nix keeps tracking branches; only flake.lock is changed. Inputs are
# read from flake.lock; any non-github input must be added to SKIP or the script fails.
#
#   scripts/update.sh              # 7 days ago
#   AGE=now scripts/update.sh      # bypass cooldown (urgent security fix)
# Set GITHUB_TOKEN to avoid the unauthenticated API rate limit (60/h).
set -euo pipefail

AGE="${AGE:-7 days ago}"
SKIP=(secret) # inputs deliberately not cooled (own private repo)
cd "$(dirname "${BASH_SOURCE[0]}")/.."
until=$(date -u -d "$AGE" +%Y-%m-%dT%H:%M:%SZ)

# lines of "name type owner/repo ref" (ref is HEAD for the default branch)
inputs=$(nix eval --raw --impure --expr '
  let
    l = builtins.fromJSON (builtins.readFile ./flake.lock);
    line = n: v:
      let o = l.nodes.${v}.original; in
      "${n} ${o.type} ${o.owner or "-"}/${o.repo or "-"} ${o.ref or "HEAD"}";
  in builtins.concatStringsSep "\n"
    (builtins.attrValues (builtins.mapAttrs line l.nodes.root.inputs))')

curl_args=(-fsS)
[ -z "${GITHUB_TOKEN:-}" ] || curl_args+=(-H "Authorization: Bearer $GITHUB_TOKEN")

args=()
while read -r name type repo branch; do
  [[ " ${SKIP[*]} " == *" $name "* ]] && continue
  [ "$type" = github ] || { echo "$name: unsupported input type '$type'; teach scripts/update.sh or add it to SKIP" >&2; exit 1; }
  # Newest commit on the branch with commit date <= $until.
  rev=$(curl "${curl_args[@]}" \
    "https://api.github.com/repos/$repo/commits?sha=$branch&until=$until&per_page=1" \
    | grep -m1 -oE '"sha": *"[0-9a-f]{40}"' | grep -oE '[0-9a-f]{40}') || rev=
  [ -n "$rev" ] || { echo "$name: no commit older than '$AGE'" >&2; exit 1; }
  echo "$name ($branch): $rev"
  args+=(--override-input "$name" "github:$repo/$rev")
done <<<"$inputs"

nix flake lock "${args[@]}"
git --no-pager diff -- flake.lock
