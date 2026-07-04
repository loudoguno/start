# start 🖥️ → ✨

One-touch, idempotent Mac configuration — built conversationally with
Claude Code. If a setting isn't in this repo, it doesn't exist.

## New Mac (the one-command story)

```sh
curl -fsSL https://raw.githubusercontent.com/loudoguno/start/main/bootstrap.sh | bash
```

or, by hand:

```sh
git clone https://github.com/loudoguno/start.git ~/start && cd ~/start && ./run
```

On a factory-fresh Mac, running `git` triggers the Xcode Command Line Tools
dialog — accept it, wait, then re-run the command. `./run` handles everything
else: Homebrew, Claude Code, apps, settings, dotfiles.

Run it twice: the second run should change nothing and finish in seconds.
That's the idempotency test.

## Setting up a machine (branches & tags)

First setup of a machine happens on its own short-lived branch
(`setup/<machine>`, e.g. `setup/neo`), grown over one long Claude
conversation. When the machine converges, the branch **merges to `main`**
and gets a tag like `neo/converged-2026-07-04`. Provenance ("what it took")
lives in the tag range, `logs/JOURNAL.md`, and `machines/<host>.json` —
while `main` stays the single convergent truth every machine runs.
Why not permanent per-machine branches: `docs/DECISIONS.md` D7.

## The daily loop

1. `cd ~/start && claude` — keep this open in a terminal tab
2. Say what you want changed ("make the Dock auto-hide")
3. Claude edits the repo → press the button: `./run`
4. Worked → journaled + committed forever. Didn't → tell Claude, iterate.

## What's here

```
run                  ← the button (single idempotent entrypoint)
bootstrap.sh         ← curl-able front door (clone-or-pull, then ./run)
docs/DECISIONS.md    ← why each technology/convention was chosen
Brewfile             ← apps & CLI tools (brew bundle)
macos-defaults.sh    ← system settings, one comment each
config/              ← dotfiles, symlinked to ~/.<name>
scripts/             ← bootstrap · machine-profile · link-dotfiles · register-machine · trust-fleet
machines/            ← per-machine snapshots + quirk notes (committed!) + gitignored inventory
assets/              ← user-pictures (account avatars) + wallpapers (per-machine)
logs/JOURNAL.md      ← what was asked, what was done, did it work
CLAUDE.md            ← standing instructions for Claude Code
SUGGESTIONS.md       ← opt-in ideas from machine inventories (you select)
dashboard.html       ← interactive explorer for the above (open in browser)
```

## Exploring what to add

`SUGGESTIONS.md` holds curated, **opt-in** ideas harvested from live inventories
of the existing machines (apps, CLI tools, defaults diffs). Open
`dashboard.html` in a browser to filter/search them, check the ones you want,
and copy a ready-made action plan back into the conversation. Nothing in it is
applied automatically.

## Publish (first time only)

```sh
gh repo create start --public --source=. --push   # public: fresh Macs clone over https with zero credentials
```
