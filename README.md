# nixos-dotfiles

Personal flake for my NixOS and nix-darwin hosts.

## Switch

Interactive shells set `NH_FLAKE="$HOME/nixos-dotfiles"`.

```bash
nr  # nh os switch / nh darwin switch
nrd # nh os switch --dry / nh darwin switch --dry
nb  # nh os build / nh darwin build
```

## Hosts

| Host              | Role   | Hardware                     | System             | Channel  | Notes                                                     |
| ----------------- | ------ | ---------------------------- | ------------------ | -------- | --------------------------------------------------------- |
| `aspen-lap-lavie` | Laptop | NEC Lavie Sol (Intel 226V)   | NixOS              | unstable | [notes](hosts/aspen-lap-lavie/README.md)                  |
| `cypress-lap-mbp` | Laptop | Apple MacBook Pro 14' (2023) | nix-darwin         | unstable | -                                                         |
| `juniper-srv-vm`  | Server | Minisforum N5 NAS (AMD 255)  | Proxmox VM (NixOS) | stable   | Currently stub<br>[notes](hosts/juniper-srv-vm/README.md) |

## File Structure

```text
.
├── flake.nix              # flake entrypoint
├── modules/
│   ├── inventory/         # hosts and users
│   ├── aspects/           # reusable roles/features
│   └── renderers/         # builds NixOS and darwin outputs
├── hosts/                 # host-specific config
├── pkgs/                  # custom packages
├── dotfiles/              # raw dotfiles
└── secrets/               # sops-managed secrets
```

## Notes

- This flake uses [Lix](https://lix.systems/).
- [GitHub Actions](.github/workflows/update-flake.yml) automatically updates the flake lock file weekly.
