# Decisions — why this repo is the way it is

Each entry: the decision, the why, and what would make us revisit it.
Newest first. When a technology or convention gets chosen (or rejected),
it gets a line here — the repo documents itself.

## D8 · 2026-07-04 — Named `start`
Pairs with the bootstrap URL (`loudog.uno/start`) and reads right in the
one-liner: `git clone …/start && cd start && ./run`. Runner-up: `easy-setup`.
GitHub renames redirect, so changing later is cheap.

## D7 · 2026-07-04 — Branch strategy: short-lived `setup/<machine>` branches, permanent truth on `main`
Each machine's first setup happens on its own branch (`setup/neo`), built up
over one long Claude conversation. When the machine converges, the branch
**merges back to `main`** and gets a tag (`neo/converged-2026-07-04`).
"What it took to set up neo" = `git log main..neo-tag` + that machine's
JOURNAL entries + `machines/neo.json` — provenance without forking truth.
**Rejected: permanent per-machine branches.** They rot: a fix discovered on
one machine never reaches the others without cherry-pick bookkeeping, which
is the opposite of idempotent convergence. Machine differences live in
*data* (`machines/`, `Brewfile.<host>`), not in *history*.

## D6 · 2026-07-04 — No `~/.env`, no secrets, by design
This repo needs zero secrets to do its job (install, configure, symlink).
Anything that ever needs one pulls it at runtime from the macOS Keychain or
1Password CLI — never from a file this repo creates. That's what makes
"public" safe and boring. Revisit: never; if a step seems to need a secret
file, the step is designed wrong.

## D5 · 2026-07-04 — Public repo
The real requirement is unauthenticated read on a credential-less fresh Mac
(https clone before any SSH key exists). Public delivers it and enables the
curl-bootstrap URL. Safe because of D6.

## D4 · 2026-07-03 — Orchestrate, don't absorb (`~/keybindings` et al.)
This repo installs prerequisites and *calls* other repos' own setup scripts;
it never owns their files. Two systems must never both claim `~/.zshrc`
(see: the chezmoi zombie we removed on mx3, 2026-07-04). Migration of
slimmed-down keybinding pieces into `config/` may happen later, deliberately,
from the other side.

## D3 · 2026-07-03 — The homeostat model
This isn't a birth-certificate script; it's a state reconciler. Because
`./run` is idempotent it's safe on *existing* machines, so it should run on a
schedule (weekly `--check`) — drift detection is what keeps the repo alive
between rare new-machine events.

## D2 · 2026-07-03 — bash + `brew bundle` + `defaults`, not nix/ansible/chezmoi
The whole stack is readable by a human learning bash, has zero bootstrap
dependencies beyond git+brew, and macOS-native `defaults` covers settings.
nix-darwin is more rigorous and vastly more complex — wrong trade for a
personal two-machine fleet. Revisit if: machine count grows past ~4 or
Linux boxes join.

## D1 · 2026-07-03 — One entrypoint, modular inside
`./run` is the only button. Steps are separate scripts so the conversation
can grow them independently, but nobody ever has to remember a sequence.
