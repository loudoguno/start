# machine-setup 🖥️ → ✨

One-touch, idempotent Mac configuration — built conversationally with
Claude Code. If a setting isn't in this repo, it doesn't exist.

## New Mac (the one-command story)

```sh
git clone https://github.com/loudoguno/machine-setup.git && cd machine-setup && ./run
```

On a factory-fresh Mac, running `git` triggers the Xcode Command Line Tools
dialog — accept it, wait, then re-run the command. `./run` handles everything
else: Homebrew, Claude Code, apps, settings, dotfiles.

Run it twice: the second run should change nothing and finish in seconds.
That's the idempotency test.

## The daily loop

1. `cd machine-setup && claude` — keep this open in a terminal tab
2. Say what you want changed ("make the Dock auto-hide")
3. Claude edits the repo → press the button: `./run`
4. Worked → journaled + committed forever. Didn't → tell Claude, iterate.

## What's here

```
run                  ← the button (single idempotent entrypoint)
Brewfile             ← apps & CLI tools (brew bundle)
macos-defaults.sh    ← system settings, one comment each
config/              ← dotfiles, symlinked to ~/.<name>
scripts/             ← bootstrap · machine-profile · link-dotfiles
machines/            ← per-machine snapshots + quirk notes (committed!)
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
cd machine-setup
git init && git add -A && git commit -m "scaffold: initial machine-setup system"
gh auth login
gh repo create machine-setup --public --source=. --push   # public: fresh Macs clone over https with zero credentials
```
