# nixos-dotfiles

Personal NixOS configuration managed as a flake.

Uses [Lix](https://lix.systems).

## Hosts

| Host         | Channel        | Notes                                                |
| ------------ | -------------- | ---------------------------------------------------- |
| `lunarlavie` | nixos-unstable | hybrid disko setup; see `hosts/lunarlavie/README.md` |
| `hawknavi`   | nixos-25.11    | —                                                    |

## Structure

```
flake.nix              # mkHost helper, nixosConfigurations
hosts/<name>/          # per-host config, hardware-configuration.nix, optional disko.nix
nixos/modules/         # NixOS modules (hardware, roles, services, etc.)
home/
  modules/             # home-manager modules
  profiles/            # per-user/host home-manager entrypoints
config/                # raw dotfiles linked via xdg-dotfiles
secrets/               # sops-nix encrypted secrets
```

## Flake Key inputs

| Input                                  | Purpose                       |
| -------------------------------------- | ----------------------------- |
| `home-manager` / `home-manager-stable` | user environment              |
| `disko`                                | declarative disk partitioning |
| `sops-nix`                             | secrets management            |
| `stylix`                               | system-wide theming           |
| `nvf`                                  | Neovim config framework       |
| `zen-browser` / `helium-browser`       | browser flakes                |
| `dms-plugin-registry`                  | Niri desktop plugins          |
