#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  register-machine.sh — write this machine's FULL inventory record
#  to machines/<host>.inventory.json. Idempotent: re-running just
#  refreshes it. No external deps (no jq) — emits JSON via a heredoc.
#
#  Captures identity (serial/UUID/model), network (MACs + Tailscale),
#  and SSH public keys — enough for another machine to add this one
#  to known_hosts + authorized_keys.
#
#  ⚠️  Serials + MACs are secrets per this repo's CLAUDE.md, and
#  `start` is PUBLIC. So *.inventory.json is GITIGNORED and must
#  never be committed. This is DISTINCT from machines/<host>.json,
#  the secrets-free snapshot owned by scripts/machine-profile.sh.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$REPO/machines"
mkdir -p "$OUT_DIR"

host="$(scutil --get LocalHostName 2>/dev/null || hostname -s)"
computer="$(scutil --get ComputerName 2>/dev/null || echo "$host")"
hw() { system_profiler SPHardwareDataType 2>/dev/null | awk -F': ' "/$1/{print \$2; exit}"; }

model_name="$(hw 'Model Name')"
model_id="$(hw 'Model Identifier')"
chip="$(hw 'Chip')"
cores="$(hw 'Total Number of Cores')"
memory="$(hw 'Memory')"
serial="$(hw 'Serial Number')"
uuid="$(hw 'Hardware UUID')"
os_ver="$(sw_vers -productVersion)"
os_build="$(sw_vers -buildVersion)"
en0="$(ifconfig en0 2>/dev/null | awk '/ether/{print $2}')"
en1="$(ifconfig en1 2>/dev/null | awk '/ether/{print $2}')"

ts_bin=""
for c in /Applications/Tailscale.app/Contents/MacOS/Tailscale "$(command -v tailscale || true)"; do
  [ -x "$c" ] && ts_bin="$c" && break
done
ts4="$("$ts_bin" ip -4 2>/dev/null | head -1 || true)"
ts6="$("$ts_bin" ip -6 2>/dev/null | head -1 || true)"

host_ed="$(cat /etc/ssh/ssh_host_ed25519_key.pub 2>/dev/null | awk '{print $1" "$2}')"

# user public keys → JSON object of {filename: "type key comment"}
user_keys=""
for f in "$HOME"/.ssh/*.pub; do
  [ -e "$f" ] || continue
  name="$(basename "$f")"
  val="$(tr -d '\n' < "$f" | sed 's/"/\\"/g')"
  user_keys+="    \"$name\": \"$val\",\n"
done
user_keys="$(printf '%b' "$user_keys" | sed '$ s/,$//')"

cat > "$OUT_DIR/$host.inventory.json" <<JSON
{
  "host": "$host",
  "computerName": "$computer",
  "role": "TODO: describe this machine's role",
  "hardware": {
    "modelName": "$model_name",
    "modelIdentifier": "$model_id",
    "chip": "$chip",
    "cores": "$cores",
    "memory": "$memory",
    "serialNumber": "$serial",
    "hardwareUUID": "$uuid"
  },
  "os": { "product": "macOS", "version": "$os_ver", "build": "$os_build" },
  "network": {
    "macAddresses": { "en0": "$en0", "en1": "$en1" },
    "tailscale": { "v4": "$ts4", "v6": "$ts6" }
  },
  "ssh": {
    "hostKey_ed25519": "$host_ed",
    "userKeys": {
$(printf '%b' "$user_keys")
    }
  },
  "registeredAt": "$(date +%Y-%m-%d)"
}
JSON

echo "✅ wrote machines/$host.inventory.json (gitignored — contains secrets)"
