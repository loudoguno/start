#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  trust-fleet.sh — teach THIS machine to trust the rest of the
#  fleet, using the records in machines/*.json.
#
#  Default: add every other machine's SSH host key to known_hosts
#  (so `ssh <host>` doesn't prompt on first connect).
#  With --authorize: also add every machine's USER public keys to
#  this machine's ~/.ssh/authorized_keys (so they can ssh IN here).
#
#  Requires: jq (in the Brewfile).
# ═══════════════════════════════════════════════════════════════
set -euo pipefail
command -v jq >/dev/null || { echo "❌ needs jq (brew install jq)"; exit 1; }
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SELF="$(scutil --get LocalHostName 2>/dev/null || hostname -s)"
AUTH=0; [ "${1:-}" = "--authorize" ] && AUTH=1
mkdir -p "$HOME/.ssh"; touch "$HOME/.ssh/known_hosts"

add_line() { grep -qxF "$1" "$2" 2>/dev/null || { echo "$1" >> "$2"; echo "  + $2: ${1:0:48}…"; }; }

for f in "$REPO"/machines/*.inventory.json; do
  [ -e "$f" ] || continue
  base="$(basename "$f")"
  [ "$base" = "_example.inventory.json" ] && continue
  host="$(jq -r '.host // empty' "$f")"
  [ "$host" = "$SELF" ] && continue          # don't trust yourself
  ts4="$(jq -r '.network.tailscale.v4 // empty' "$f")"
  hk="$(jq -r '.ssh.hostKey_ed25519 // empty' "$f")"
  echo "→ $host"
  if [ -n "$hk" ]; then
    for name in "$host" "$ts4"; do
      [ -n "$name" ] && add_line "$name $hk" "$HOME/.ssh/known_hosts"
    done
  fi
  if [ "$AUTH" = 1 ]; then
    touch "$HOME/.ssh/authorized_keys"; chmod 600 "$HOME/.ssh/authorized_keys"
    while IFS= read -r k; do
      [ -n "$k" ] && add_line "$k" "$HOME/.ssh/authorized_keys"
    done < <(jq -r '.ssh.userKeys // {} | to_entries[]?.value' "$f")
  fi
done
echo "✅ fleet trust updated (authorize=$AUTH)"
