#!/usr/bin/env bash
# Symlinks every file in config/ into $HOME with a leading dot:
#   config/zshrc  →  ~/.zshrc
# Idempotent: ln -sfn just re-points existing links. Real files that
# would be clobbered get backed up once as <name>.pre-setup.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$REPO_DIR/config"

shopt -s nullglob
for src in "$CONFIG_DIR"/*; do
  name="$(basename "$src")"
  [[ "$name" == "README.md" ]] && continue
  dest="$HOME/.$name"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "↪ Backing up existing $dest → $dest.pre-setup"
    mv "$dest" "$dest.pre-setup"
  fi

  ln -sfn "$src" "$dest"
  echo "🔗 $dest → $src"
done

echo "✅ Dotfiles linked."
