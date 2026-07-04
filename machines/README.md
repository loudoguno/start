# machines/ — where each setting was validated

Two files per machine, keyed by hostname:

- `<host>.json` — auto-generated snapshot (model, chip, macOS version/build,
  beta seed enrollment, last run time). Owned by scripts/machine-profile.sh.
  **Never hand-edit.**
- `<host>.notes.md` — quirks and deviations discovered on that machine
  ("key X moved in build Y; guarded in macos-defaults.sh"). Maintained by
  Claude Code during the loop.

These are committed on purpose: they travel with the repo, so a new machine
knows what context the settings were proven in.
