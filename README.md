# NixOS Configuration

This is my NixOS configuration. I'm basing it off of a video by Matthias Benaets.


## Building

Run the following to rebuild the system with the configuration.

```sh
sudo nixos-rebuild switch --flake .#<machine>
```

Where `<machine>` is replaced with one of the specific machine types:
- `desttop`
- `destbook`
- `destphone`
