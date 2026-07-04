# machines/ — where each setting was validated + fleet inventory

Two layers live here.

## 1. Profile snapshots (committed, secrets-free) — the existing convention

Two files per machine, keyed by hostname:

- `<host>.json` — auto-generated snapshot (model, chip, macOS version/build,
  beta seed enrollment, last run time). Owned by `scripts/machine-profile.sh`.
  **Never hand-edit.**
- `<host>.notes.md` — quirks and deviations discovered on that machine
  ("key X moved in build Y; guarded in macos-defaults.sh"). Maintained by
  Claude Code during the loop.

These are committed on purpose: they travel with the repo, so a new machine
knows what context the settings were proven in. They contain **no secrets**.

## 2. Inventory records (gitignored) — identity + SSH trust

For fleet SSH bootstrap you need serials, MACs, Tailscale IPs, and SSH keys —
richer than the snapshot, and (for the serial/MAC/IP parts) **secret**.

- `<host>.inventory.json` — full record. **Gitignored** (see hard rule below).
  Written by `scripts/register-machine.sh`.
- `_example.inventory.json` — the schema, committed as documentation.

### Register the current machine

```sh
./scripts/register-machine.sh        # writes machines/<host>.inventory.json
```

Idempotent — re-run when hardware/keys/IPs change. Fill in `role` by hand.

### Trust the rest of the fleet

```sh
./scripts/trust-fleet.sh             # other machines' host keys → known_hosts
./scripts/trust-fleet.sh --authorize # ALSO their user keys → authorized_keys (they can ssh IN)
```

Skips the current machine, idempotent, requires `jq` (in the Brewfile).

### ⚠️ Hard rule + the visibility decision

This repo's `CLAUDE.md` says **"No secrets in this repo, ever — serial
numbers"**, and `start` is a **public** GitHub repo. So `*.inventory.json`
is gitignored and must never be committed. To actually propagate inventory
across machines, pick one:

1. **Make `start` private** — then inventory can be tracked directly and the
   no-secrets rule relaxes to "no secrets in a *public* repo." Recommended for
   a personal bootstrap repo. (Note: the `curl | bash` one-liner in the top
   README would then need an auth token.)
2. **Keep `start` public** — sync `*.inventory.json` through a private channel
   (a private repo, the NAS, or Tailscale-only storage). SSH *public* keys are
   safe to share, but serials/MACs/IPs are not.

Undecided until you say so.
