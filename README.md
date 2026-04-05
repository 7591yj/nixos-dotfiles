# nixos-dotfiles

Personal NixOS and nix-darwin flake for my machines.

This repo keeps host configs, dendritic flake-parts modules,
lower-level NixOS/Home Manager/nix-darwin modules, custom packages,
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

For nix-darwin hosts:

```bash
nix build .#darwinConfigurations.<host>.system
darwin-rebuild switch --flake .#<host>
```

### aspen-lap-lavie

[README](hosts/aspen-lap-lavie/README.md)

Intel-based laptop, using `nixos-unstable`.

### juniper-srv-vm

[README](hosts/juniper-srv-vm/README.md)

Server VM targeting Proxmox, using `nixos-25.11`.

## Layout

```text
flake.nix                 # flake entrypoint
flake/modules/            # import-tree-discovered top-level modules
flake/modules/aspects/    # den-style aspect definitions
hosts/                    # host-specific state and templates
modules/                  # lower-level implementation modules
pkgs/                     # custom packages
dotfiles/                 # raw config files
secrets/                  # encrypted secrets
```

## Notes

- `flake.nix` now uses `import-tree` once to discover the top-level flake modules.
- Hosts and users now select named `repo.aspects`, and those aspects carry
  the NixOS/Home Manager/nix-darwin modules they apply across classes.
- This configuration makes use of [Lix](https://lix.systems/) rather than flat Nix.
