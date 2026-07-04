# 📜 Setup Journal

A running record of every change: what was wanted, what was done, whether
it worked, and on which machine. Newest entries first. Claude Code writes
these; the format lives in CLAUDE.md.

<!-- NEW ENTRIES BELOW -->

## 2026-07-03 — Inventory of mx3 + mxb → suggestions catalog + dashboard
- **Asked:** Survey both existing Macs (apps, CLI tools, curated defaults), produce an opt-in list of ideas with incorporation actions, plus an interactive HTML dashboard for exploring it — nothing auto-added; Lou selects
- **Done:** Read-only inventories of mx3 (local) and mxb (over SSH); `SUGGESTIONS.md` (30 items, categories A–F, anchored in observed diffs); `dashboard.html` (self-contained: search, category filters, tooltips, checkbox→copyable action plan, light/dark); README `YOURUSER`→`loudoguno` + publish set to `--public`; CLAUDE.md file map row for the new files; `git init` + initial commits. Notable finds: chezmoi installed on neither machine yet mx3 runs a failing chezmoi-sync LaunchAgent since 2026-03-10; InitialKeyRepeat 120 vs 15; `jq`/`ripgrep` on neither machine
- **Result:** ✅ files in place; `./run` itself still ⚠️ pending first execution on real hardware
- **Machine:** authored on mx3 (Mac Studio-class desktop) · macOS 27.0 (26A5368g); mxb inventoried remotely
- **Commit:** see git log (scaffold + suggestions commits)

## 2026-07-03 — Repo scaffolded
- **Asked:** A clonable, self-documenting setup repo with change logging and per-machine profiles
- **Done:** Initial structure — `run`, `Brewfile` (core stack + PAI deps), `macos-defaults.sh` (trackpad trio), `scripts/` (bootstrap, machine-profile, link-dotfiles), `CLAUDE.md` conventions
- **Result:** ⚠️ pending first `./run` on real hardware
- **Machine:** n/a — scaffolded off-device
- **Commit:** initial
