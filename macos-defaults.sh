#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  All macOS system settings live here. One plain-English comment
#  per setting. Grouped by domain. Naturally idempotent: writing
#  the same value twice is a no-op.
#
#  NOTE: defaults are PER-USER. Run under each account that wants them.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail
NEEDS_LOGOUT=0

### Trackpad ─────────────────────────────────────────────────────

# Scroll direction: traditional, not "natural" (content moves opposite
# to finger direction — the non-default way)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Tap to click — written to every domain macOS consults so it sticks
# for built-in and Bluetooth trackpads
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
NEEDS_LOGOUT=1

# Trackpad tracking speed: maximum (scale runs 0–3)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0

### Apply ────────────────────────────────────────────────────────

# Restart the services that cache these settings
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

if [[ "$NEEDS_LOGOUT" == "1" ]]; then
  echo ""
  echo "⚠️  ═══════════════════════════════════════════════════"
  echo "⚠️   LOGOUT REQUIRED for some settings (tap-to-click)"
  echo "⚠️   to fully take effect. Log out and back in."
  echo "⚠️  ═══════════════════════════════════════════════════"
fi
