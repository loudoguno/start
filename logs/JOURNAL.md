# 📜 Setup Journal

A running record of every change: what was wanted, what was done, whether
it worked, and on which machine. Newest entries first. Claude Code writes
these; the format lives in CLAUDE.md.

<!-- NEW ENTRIES BELOW -->

## 2026-07-04 — Account avatars, per-machine wallpapers, fleet-inventory tooling
- **Asked:** Add Lou's account-picture images; generate a themed set of avatars + minimalist per-machine desktop wallpapers (Lou / admin / dad); add a machine "inventory" (serials, MACs, Tailscale IPs, SSH pubkeys) so a new machine can trust the fleet
- **Done:** `assets/user-pictures/` (admin-gearhead, dalmatian, vaporwave — earlier commit `d4a3be1`); `assets/wallpapers/` — 3 gpt-image-1 wallpapers on a shared acorn→circuit theme (mxb dusk, admin graphite/gear, vrye cream/oak) + README; `scripts/register-machine.sh` → gitignored `machines/<host>.inventory.json`, `scripts/trust-fleet.sh` (known_hosts + `--authorize` authorized_keys), `machines/_example.inventory.json`, extended `machines/README.md`; `jq` added to Brewfile
- **Result:** ⚠️ partial by design — inventory tooling built + mxb registered locally, but real `*.inventory.json` is **gitignored** because it holds serials (CLAUDE.md hard rule) and the repo is public (D2/D-public). Propagation needs Lou's visibility decision. Dad's themed headshot deferred: no clean source photo found
- **Machine:** mxb · MacBookPro18,4 · M1 Max · macOS 27.0 (26A5368g)
- **Commit:** see git log

## 2026-07-04 — Named `start`, published public, branch strategy, bootstrap.sh, decisions doc
- **Asked:** Public repo yes; call it easy-setup "or something better"; per-machine branches so each setup is traceable; repo must document the why; kill mx3's chezmoi-sync LaunchAgent; design loudog.uno/start
- **Done:** Renamed repo `start` (pairs with the future `loudog.uno/start` URL); `docs/DECISIONS.md` (D1–D8: bash+brew not nix, no secrets/no ~/.env by design, public, one entrypoint, homeostat cadence, orchestrate-don't-absorb, short-lived `setup/<machine>` branches merged to main + `<machine>/converged-<date>` tags); `bootstrap.sh` curl-able front door; README/CLAUDE.md updated; published `github.com/loudoguno/start` (public). Also removed mx3's zombie `com.loudog.chezmoi-sync` LaunchAgent (pieces backed up to `~/.local/share/removed-chezmoi-sync-2026-07-04/`)
- **Result:** ✅ published; `./run` still ⚠️ pending first execution on real hardware (planned: macbook "neo" on `setup/neo`)
- **Machine:** authored on mx3 · macOS 27.0 (26A5368g)
- **Commit:** see git log

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
