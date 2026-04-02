# nixos-dotfiles

Personal NixOS flake for my machines.

This repo keeps host configs, shared modules, Home Manager profiles, custom packages,
and a small set of raw dotfiles in one place.

## Hosts

Building a host:

```bash
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
```

Applying a host locally:

> Using `nixx` shorthand is feasible after initial run.

```bash
sudo nixos-rebuild switch --flake .#<host>
```

### aspen-lap-lavie

[README](hosts/aspen-lap-lavie/README.md)

Intel-based laptop, using `nixos-unstable`.

### juniper-srv-vm

[README](hosts/juniper-srv-vm/README.md)

Server VM targeting Proxmox, using `nixos-25.11`.

## Layout

```text
flake.nix        # flake entrypoint
flake/parts/     # host definitions and shared helpers
hosts/           # per-host NixOS configs
homes/           # Home Manager profiles
modules/         # shared NixOS and HM modules
pkgs/            # custom packages
dotfiles/        # raw config files
secrets/         # encrypted secrets
```

## Notes

- `flake/parts/lib.nix` defines `mkNixosSystem`, the helper used by each host.
- This configuration makes use of [Lix](https://lix.systems/) rather than flat Nix.
