# nixos-dotfiles

Personal NixOS configuration.

Uses [Lix](https://lix.systems).

## Hosts

| Host              | Channel        | Notes                                                     |
| ----------------- | -------------- | --------------------------------------------------------- |
| `aspen-lap-lavie` | nixos-unstable | hybrid disko setup; see `hosts/aspen-lap-lavie/README.md` |
| `juniper-srv-vm`  | nixos-25.11    | used as a vm on top of proxmox                            |

## Structure

```text
flake.nix              # flake-parts entrypoint
flake/parts/           # flake-parts modules (hosts + shared helpers)
hosts/<name>/          # per-host config, hardware-configuration.nix, optional disko.nix
nixos/modules/         # NixOS modules (hardware, roles, services, etc.)
home/
  modules/             # home-manager modules
  profiles/            # per-user/host home-manager entrypoints
config/                # raw dotfiles linked via xdg-dotfiles
secrets/               # sops-nix encrypted secrets
```

### Variables

`mkNixOSSystem` in `flake/parts/lib.nix` manages all the variables for the given
system.

- `hostname`: hostname of the system
- `system`: system type (defaults to `x86_64-linux`)
- `nixpkgsInput`: nixpkgs to use (defaults to `unstable`)
- `homeManagerInput`: home-manager to use (defaults to the master branch)
- `homeProfile`: filename in `home/profiles` (defaults to `null` (do not use
  home-manager))
- `useStylix`: whether to use Stylix (defaults to `false`)
- `useDisko`: whether to use Disko (defaults to `false`)

Variables are to be managed in `flake/parts/nixos/<system-name>.nix`.

### Desktop

`config.mySystem.desktop.compositor` manages the window server to be used on the
system.

#### Wayland

- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
- [niri](https://github.om/niri-wm/niri)

### Server

## Flake Key inputs

| Input          | Purpose                       |
| -------------- | ----------------------------- |
| `home-manager` | user environment              |
| `disko`        | declarative disk partitioning |
| `sops-nix`     | secrets management            |
| `stylix`       | system-wide theming           |
| `nvf`          | Neovim config framework       |
