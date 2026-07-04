# start — Instructions for Claude Code

You are the co-pilot for an idempotent Mac configuration system. The human
talks; you edit this repo; `./run` makes it real. Nothing gets changed on the
machine by hand — ever. **If it isn't in this repo, it doesn't exist.**

## Prime directive
The end product is a one-touch button: `git clone && ./run` recreates the
entire setup on any Mac. Every change you make must preserve that.

## File map — where things go
| Change type | Goes in |
|---|---|
| App / CLI tool | `Brewfile` (GUI apps as `cask`) |
| macOS system setting | `macos-defaults.sh` (grouped by domain) |
| Dotfile / app config | `config/` (symlinked to `~/.<name>` by `scripts/link-dotfiles.sh`) |
| Prerequisite installers | `scripts/bootstrap.sh` |
| Machine-specific quirks | `machines/<host>.notes.md` |
| History of every change | `logs/JOURNAL.md` |
| Opt-in ideas (human selects; never auto-applied) | `SUGGESTIONS.md` + `dashboard.html` |
| Why a technology/convention was chosen or rejected | `docs/DECISIONS.md` (append an entry when deciding) |

## Branches & tags
- First setup of a machine: short-lived branch `setup/<machine>`, grown
  during the conversation, **merged to `main` when the machine converges**,
  then tagged `<machine>/converged-YYYY-MM-DD`.
- `main` is the single convergent truth all machines run. Never leave a
  machine on a long-lived branch; machine differences belong in data
  (`machines/`, `Brewfile.<host>`), not in git history. Rationale: D7.

## Idempotency contract
- `./run` must be safe to run repeatedly. Two consecutive runs: the second
  changes nothing and finishes fast.
- Prefer declarative forms (`brew bundle`, `defaults write`, `ln -sfn`).
- Guard anything that isn't naturally idempotent.

## The loop (follow this on every request)
1. **Listen.** The human states a desire in plain language.
2. **Edit** the right file(s). Every setting gets a one-line plain-English
   comment saying what it does.
3. **Explain** the change in 1–3 sentences. Offer to run `./run` yourself,
   or let the human press the button.
4. **Verify.** Ask whether it took effect. If not, iterate — fix the
   script, never the machine.
5. **Journal.** Once the outcome is known, add an entry to
   `logs/JOURNAL.md` (format below), including the final status.
6. **Commit.** One commit per accepted change, message like
   `feat(trackpad): tap-to-click + max tracking speed`.

## Journal entry format
Insert below the `<!-- NEW ENTRIES BELOW -->` marker in `logs/JOURNAL.md`,
newest first:

    ## YYYY-MM-DD — Short title
    - **Asked:** what the human said they wanted (their words, roughly)
    - **Done:** what changed, which files, key commands
    - **Result:** ✅ worked / ⚠️ partial (details) / ❌ failed → next step
    - **Machine:** model · macOS version (build) — from `machines/<host>.json`
    - **Commit:** short hash

If a change takes multiple attempts, keep ONE entry and let its Result line
tell the story ("failed on first run: wrong defaults domain; fixed with …").
Dead ends are valuable data — future machines will hit them too.

## Machine awareness
- `scripts/machine-profile.sh` snapshots this machine to
  `machines/<host>.json` on every run. These files are **committed** — they
  travel with the repo as a record of where each setting was validated.
- At the start of a session, read the current host's `.json` and `.notes.md`
  if they exist. They tell you the OS build you're targeting and known quirks.
- When something behaves differently on a given OS version or build:
  1. Make the script handle both (version-guard using `sw_vers`), and
  2. Record the deviation in `machines/<host>.notes.md`.
- Never assume a defaults key that worked on one build works on another —
  this machine may be running a beta.

## Hard rules
- **No secrets** in this repo, ever (tokens, passwords, serial numbers).
- **Never add Wispr Flow to the Brewfile** — it is installed manually, last,
  outside brew, to capture a referral credit.
- Ask before anything destructive or anything requiring `sudo`.
- Keep bash readable — the humans here are learning. Comments over cleverness.
- Don't edit `machines/*.json` by hand; the profiler owns those. You own the
  `.notes.md` files.

## Vocabulary
- "The button" = `./run`
- "Journal it" = write the JOURNAL.md entry
- "The loop" = steps 1–6 above
