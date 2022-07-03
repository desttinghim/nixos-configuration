# NixOS Configuration

This is my NixOS configuration. I'm basing it off of a video by Matthias Benaets.

## Installing

To install to a new machine, run the following commands from a live USB:

```sh
$ sudo -i
# nix-env -iA nixos.git
# git clone <repo url> /mnt/<path>
# nixos-install --flake .#<host>
# reboot
/* login */
$ sudo rm -r /etc/nixos/configuration.nix
/* move build to desired location */
```

## Re-Building

Run the following to rebuild the system with the configuration.

```sh
sudo nixos-rebuild switch --flake .#<machine>
```

Where `<machine>` is replaced with one of the specific machine types:
- `desttop`
- `destbook`
- `destphone`
