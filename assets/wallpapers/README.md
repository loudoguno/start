# assets/wallpapers/ — per-machine desktop backgrounds

Minimalist wallpapers, one per account, so a screenshot instantly tells you
which machine (and which account) it came from. Shared visual language:
lots of negative space, one motif, a small monospace label in the corner.

| File | Account | Look | Motif |
|------|---------|------|-------|
| `wallpaper-mxb.png` | Lou (mxb) | dusk indigo → plum | acorn sprouting into a gold node-constellation |
| `wallpaper-admin.png` | admin | cool graphite + dot-grid | single thin gear glyph |
| `wallpaper-vrye.png` | dad (Vrye) | warm cream & oak | acorn growing into a branching circuit-tree |

Design idea: the acorn (a nod to **Vrye Advisors**) as a *seed that grows* —
heritage sprouting into an augmented, agentic future. The human machines share
that acorn→circuit motif; admin gets the utilitarian gear instead.

1536×1024, generated with OpenAI `gpt-image-1`. Set one:

```sh
osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "'"$PWD/wallpaper-mxb.png"'"'
```
