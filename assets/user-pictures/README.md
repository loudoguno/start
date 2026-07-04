# assets/user-pictures/ — account avatars

The images Lou uses for macOS user account pictures. Kept in the repo so a
fresh machine can be set up with the same faces instead of the stock
`/Library/User Pictures/` flowers-and-dandelions.

| File | Subject | Intended account |
|------|---------|------------------|
| `admin-gearhead.png` | Vaporwave gearhead in a suit | **admin** |
| `dalmatian.jpg` | Dalmatian headshot | standard / secondary user |
| `vaporwave-headshot.png` | Lou's vaporwave headshot | **loudog** (primary) |

## Setting one as an account picture

Per-user, after login as that account:

```sh
# GUI: System Settings → Users & Groups → click the avatar → drag the file in.
```

Or from the command line (needs admin rights; substitute the account short name
and the picture you want):

```sh
sudo dscl . delete /Users/<shortname> JPEGPhoto
sudo dscl . delete /Users/<shortname> Picture
sudo dscl . create /Users/<shortname> Picture "/path/to/start/assets/user-pictures/vaporwave-headshot.png"
```

macOS also caches the login/lock-screen picture; a logout is enough to refresh it.
