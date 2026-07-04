# SUGGESTIONS — opt-in ideas from the mx3 ↔ mxb inventory (2026-07-03)

> **Nothing here is wired into `./run`.** Every item is a suggestion with a ready-to-paste
> action. Lou selects; the conversation incorporates. Browse these interactively in
> [`dashboard.html`](dashboard.html) (open it in a browser — checkboxes there build a
> copy-paste action plan).
>
> Source data: live inventory of both machines (read-only), 2026-07-03. Machines:
> **mx3** (primary desktop, macOS 27.0) · **mxb** (2021 M1 Max MBP, macOS 27.0).

## A. Harden this repo (machine-setup itself)

| ID | Suggestion | Why | Action |
|----|------------|-----|--------|
| A1 | ~~`git init` + initial commit~~ **done 2026-07-03** | Wasn't a git repo yet; publish steps in README never run | done locally; `gh repo create machine-setup --public --source=. --push` when ready |
| A2 | ~~Fix `YOURUSER` in README clone URL~~ **done** | Placeholder would break the one-command story | replaced with `loudoguno` |
| A3 | Add `./run --check` doctor mode | Idempotency needs proof: a dry-run that prints `OK` / `WOULD CHANGE` per step without touching anything | add `CHECK=1` env respected by each script; `[[ "${1:-}" == "--check" ]] && export CHECK=1` in `run` |
| A4 | Run-twice invariant + shellcheck CI | Second consecutive `./run` must be all no-ops; lint every script on push | `.github/workflows/ci.yml` running `shellcheck scripts/* run` (macOS runner can even run `./run` twice) |
| A5 | Manual-steps checklist printer | TCC dialogs (Karabiner Input Monitoring/Accessibility), App Store & 1Password sign-in, Wispr Flow manual install can't be automated — print them at the end of `./run` instead of forgetting them | `scripts/manual-checklist.sh` echoing a numbered checklist; `run` calls it last |
| A6 | Per-machine Brewfile layering | mx3 and mxb legitimately differ; one Brewfile forces lowest-common-denominator | `Brewfile` (common) + `Brewfile.$(scutil --get LocalHostName)`; `run` bundles both if present |
| A7 | Secrets tripwire before every push | Repo is destined to be public | `brew "gitleaks"` + `.git/hooks/pre-push` running `gitleaks protect --staged` (mxb already has gitleaks + trufflehog) |

## B. Bootstrap gaps (what a fresh Mac actually needs for Lou's stack)

| ID | Suggestion | Why | Action |
|----|------------|-----|--------|
| B1 | Step: clone + wire `~/keybindings` | It's the real dotfile owner (zshrc, karabiner, slate, ghostty via symlinks); docs/SETUP-NEW-MACHINE.md sequence is exactly scriptable | `scripts/keybindings.sh`: clone `git@github.com:loudoguno/keybindings.git` (or https on fresh box), `./scripts/setup-symlinks.sh`, `goku`, `./scripts/health-check.sh` |
| B2 | Brewfile: everything `shell/zshrc` assumes | zshrc sources tools that vanilla macOS lacks — shell breaks visibly on a fresh machine | add: `tap "yqrashawn/goku"`, `brew "goku"`, `cask "karabiner-elements"`, `brew "fzf"`, `brew "bat"`, `brew "neovim"`, `brew "bun"`, `brew "fabric-ai"` |
| B3 | Seed `~/.env` + `~/.zshrc.local` | Untracked-by-design; fresh shells error until they exist | step copying `shell/env.example` → `~/.env` and `zshrc.local.example` → `~/.zshrc.local` **only if missing** |
| B4 | Resolve the chezmoi zombie | chezmoi is installed on **neither** machine, yet mx3's `com.loudog.chezmoi-sync` LaunchAgent has errored every ~30 min since 2026-03-10, and `health-check.sh` carries dead chezmoi sections that report "in sync" vacuously | either adopt chezmoi for real (it overlaps keybindings' symlinks — two owners of `~/.zshrc`) or: `launchctl unload ~/Library/LaunchAgents/com.loudog.chezmoi-sync.plist && rm` + strip health-check.sh:39-88,131-147 |
| B5 | Fix `setup-symlinks.sh` re-run bug | karabiner/.slate/DefaultKeyBinding.dict backups use `[[ -e ]]` (true for symlinks) → a 2nd run moves the *symlink* onto `.bak`, destroying the real-file backup | add `&& ! -L` to those three guards (ghostty/zshrc already have it) |

## C. CLI parity (observed on exactly one machine)

| ID | Suggestion | Why | Action |
|----|------------|-----|--------|
| C1 | mxb → everywhere: `fd`, `glow`, `tldr`, `tree`, `mas`, `watchexec`, `gitleaks` | Daily-driver quality-of-life CLIs mx3 is missing | add to common Brewfile |
| C2 | mx3 → mxb: `bat`, `pandoc`, `go`, `vercel-cli`, `vhs`, `unar` | Present only on mx3; vhs/pandoc used in doc workflows | add to common Brewfile |
| C3 | On neither (surprising): `jq`, `ripgrep`, `shellcheck` | jq for the `machines/*.json` snapshots; rg for everything; shellcheck for A4 | `brew "jq"`, `brew "ripgrep"`, `brew "shellcheck"` |
| C4 | Heavy/dev extras from mxb, case-by-case: `ffmpeg`, `nmap`, `cloudflared`, `flyctl`, `trufflehog`, `rich-cli` | Real use on mxb; decide per-machine (A6 layering) | `Brewfile.mx3` additions as desired |

## D. App parity (casks; Setapp-managed apps excluded on purpose)

| ID | Suggestion | Why | Action |
|----|------------|-----|--------|
| D1 | QuickLook suite (mxb-only) → mx3 | `qlmarkdown`, `qlstephen`, `quicklook-json`, `qlcolorcode`, `qlvideo` make spacebar preview actually useful | add casks |
| D2 | mxb-only worth considering on mx3: `appcleaner`, `keyclu`, `vlc`, `font-fira-code-nerd-font`, `tower` | KeyClu overlaps KeyCue (already on mx3) — pick one | add selected casks |
| D3 | mx3-only worth considering on mxb: `aerospace`, `homerow`, `leader-key`, `keyboard-cowboy`, `cmux` | Keyboard-driven stack asymmetry | add selected casks |
| D4 | Brewfile-ify unmanaged apps | Raycast, Alfred, Obsidian, Karabiner-Elements, Keyboard Maestro exist in `/Applications` outside brew on at least one machine — untracked = invisible to the manifest | `brew bundle dump` then curate; install future copies via cask so the Brewfile stays truthful |
| D5 | Setapp as an explicit step | BetterTouchTool, CleanShot X, Hookmark, iStat run as login items but live in Setapp — a silent dependency of "my machine feels right" | `cask "setapp"` + Setapp sign-in on the A5 manual checklist |
| D6 | ⚠️ Wispr Flow stays manual | House rule (CLAUDE.md): never in Brewfile — manual install preserves referral credit | listed on the A5 manual checklist only |

## E. macOS defaults to reconcile (live diffs between the two machines)

| ID | Setting | mx3 | mxb | Suggested action |
|----|---------|-----|-----|------------------|
| E1 | `InitialKeyRepeat` | **120** (≈1.8 s delay) | **15** (fast) | 120 looks accidental for a keyboard-first user — if intended (hyper-key timing?), document why in `machines/mx3.notes.md`; else `defaults write -g InitialKeyRepeat -int 15` |
| E2 | `AppleKeyboardUIMode` | 1 | 3 | 3 = full keyboard access (Tab reaches every control) — fits the stack: `defaults write -g AppleKeyboardUIMode -int 3` |
| E3 | Screenshot `style` | display | window (+clicks,+cursor) | pick one; `defaults write com.apple.screencapture style -string window` |
| E4 | Dock `tilesize` | 40 | 16 | standardize or keep per-machine (A6); `defaults write com.apple.dock tilesize -int 40` |
| E5 | Finder `ShowStatusBar` | 0 | 1 | `defaults write com.apple.finder ShowStatusBar -bool true` |
| E6 | `NSAutomaticSpellingCorrectionEnabled` | unset (on) | 1 | keyboard purists usually disable: `defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false` |
| E7 | `mouse.scaling` | 1 | 3 | intentional (desktop vs laptop)? document in notes.md |
| E8 | Fold winners into `macos-defaults.sh` | — | — | add a `keyboard`/`finder`/`dock` group next to the existing trackpad trio |

## F. Ops hygiene surfaced by the inventory

| ID | Suggestion | Why | Action |
|----|------------|-----|--------|
| F1 | Reconcile mxb's `~/keybindings` | On branch `maxbook-pro` with uncommitted `shell/zshrc` change; mx3's is also dirty — the "git-only sync" story currently has both ends diverging | commit/merge both toward `main` |
| F2 | Three remap engines coexist on mx3 | Karabiner/goku + `kanata` + `skhd`/`yabai` taps installed — potential input-event fights | decide the stack; uninstall the losers |
| F3 | Nightly `./run --check` LaunchAgent | The homeostat model: drift detection between new-machine events is what keeps this repo alive | after A3 exists, a LaunchAgent runs the check weekly and notifies on WOULD-CHANGE |
