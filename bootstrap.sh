#!/bin/bash
# bootstrap.sh — the curl-able front door.
#   curl -fsSL https://raw.githubusercontent.com/loudoguno/start/main/bootstrap.sh | bash
# (later: curl -fsSL https://loudog.uno/start | bash — same file, nicer URL)
#
# Idempotent: clones the repo to ~/start on first run, pulls on later runs,
# then presses the button. Safe to re-run any time.
set -euo pipefail

REPO_URL="https://github.com/loudoguno/start.git"   # https on purpose: fresh Macs have no SSH keys
DEST="$HOME/start"

# git lives inside Xcode Command Line Tools; asking for git triggers the CLT
# install dialog on a factory-fresh Mac. Accept it, wait, re-run this command.
if ! xcode-select -p >/dev/null 2>&1; then
  echo "→ Xcode Command Line Tools needed. Triggering the installer…"
  xcode-select --install || true
  echo "  Accept the dialog, wait for it to finish, then re-run this command."
  exit 1
fi

if [[ -d "$DEST/.git" ]]; then
  echo "→ ~/start exists — pulling latest"
  git -C "$DEST" pull --ff-only
else
  echo "→ Cloning $REPO_URL → $DEST"
  git clone "$REPO_URL" "$DEST"
fi

echo "→ Pressing the button"
exec "$DEST/run"
