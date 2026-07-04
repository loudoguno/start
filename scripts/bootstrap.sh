#!/usr/bin/env bash
# Installs the three things the rest of the system depends on.
# Idempotent: skips anything already present.
set -euo pipefail

echo "🥾 Bootstrap: checking prerequisites…"

# ── Xcode Command Line Tools (compilers + git) ─────────────────
if ! xcode-select -p >/dev/null 2>&1; then
  echo "→ Installing Xcode Command Line Tools (a macOS dialog will appear)…"
  xcode-select --install || true
  echo "  ⏸  Finish the CLT installer, then run ./run again."
  exit 1
fi

# ── Homebrew ───────────────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  # Maybe it's installed but not on PATH yet (fresh shell)
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"        # Apple Silicon
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"           # Intel
  else
    echo "→ Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# Persist brew on PATH for future login shells
if ! grep -qs 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  echo "→ Added Homebrew to ~/.zprofile"
fi

# ── Claude Code (stable channel cask) ──────────────────────────
if ! command -v claude >/dev/null 2>&1; then
  echo "→ Installing Claude Code…"
  brew install --cask claude-code
  echo "  ℹ️  First launch of \`claude\` will open a browser to sign in."
fi

echo "✅ Bootstrap complete: CLT, Homebrew, and Claude Code present."
