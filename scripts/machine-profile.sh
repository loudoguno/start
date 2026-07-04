#!/usr/bin/env bash
# Captures this machine's identity + OS state into machines/<host>.json so
# the repo carries a record of exactly where each setting was validated.
# Also warns when the context changes (new machine, or OS build changed).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MACHINES_DIR="$REPO_DIR/machines"
mkdir -p "$MACHINES_DIR"

HOST="$(scutil --get LocalHostName 2>/dev/null || hostname -s)"
MODEL="$(sysctl -n hw.model 2>/dev/null || echo unknown)"
CHIP="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo unknown)"
MEM_GB="$(( $(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1073741824 ))"
OS_VER="$(sw_vers -productVersion 2>/dev/null || echo unknown)"
OS_BUILD="$(sw_vers -buildVersion 2>/dev/null || echo unknown)"
# Beta detection (heuristic): enrolled in an Apple seed program?
SEED="$(defaults read /Library/Preferences/com.apple.SeedEnrollment.plist SeedProgram 2>/dev/null || echo none)"

SNAPSHOT="$MACHINES_DIR/$HOST.json"
NOTES="$MACHINES_DIR/$HOST.notes.md"

# ── Detect context changes BEFORE overwriting the snapshot ─────
if [[ -f "$SNAPSHOT" ]]; then
  PREV_BUILD="$(grep -o '"os_build": *"[^"]*"' "$SNAPSHOT" | cut -d'"' -f4 || true)"
  if [[ -n "${PREV_BUILD:-}" && "$PREV_BUILD" != "$OS_BUILD" ]]; then
    echo "⚠️  macOS build changed since last run on this machine: $PREV_BUILD → $OS_BUILD"
    echo "    Settings were last validated on the old build. Watch for drift"
    echo "    and log anything odd in: $NOTES"
  fi
else
  echo "🆕 First run on '$HOST'."
  OTHERS="$(ls "$MACHINES_DIR"/*.json 2>/dev/null | grep -v "/$HOST.json" || true)"
  if [[ -n "$OTHERS" ]]; then
    echo "    Settings in this repo were validated on other machines:"
    while IFS= read -r f; do
      echo "      • $(basename "$f" .json)"
    done <<< "$OTHERS"
    echo "    If something behaves differently here, record it in: $NOTES"
  fi
fi

# ── Write the snapshot (auto-generated; do not hand-edit) ──────
cat > "$SNAPSHOT" <<JSON
{
  "hostname": "$HOST",
  "model": "$MODEL",
  "chip": "$CHIP",
  "memory_gb": $MEM_GB,
  "os_version": "$OS_VER",
  "os_build": "$OS_BUILD",
  "beta_seed_program": "$SEED",
  "last_run": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
JSON

# ── Seed the human/Claude-maintained notes file if missing ─────
if [[ ! -f "$NOTES" ]]; then
  cat > "$NOTES" <<MD
# $HOST — machine-specific notes

Deviations, quirks, and version guards discovered on this machine.
Maintained by Claude Code during the loop. (The .json snapshot next to
this file is auto-generated — never hand-edit that one.)
MD
fi

echo "🖥  Profiled: $MODEL · macOS $OS_VER ($OS_BUILD) · seed: $SEED"
