# lunarlavie

Intel-based laptop; NixOS with a desktop role

## Disk layout

The disk was partitioned manually before disko was introduced. `disko.nix`
describes the intended layout but is **not** the source of truth for the live
system. UUID-based references in `default.nix` keep the current install working
without GPT partition labels disko would normally set.

```
/dev/nvme0n1 (GPT)
├── ESP (512M, vfat) → /boot          UUID: 619C-5E4C
└── lvm PV → VG "vg"
    ├── root LV (btrfs)               LUKS UUID: 8f4e044b-3d7a-4bfb-b8bc-eab9fdb36645
    │   ├── @      → /
    │   ├── @home  → /home
    │   └── @nix   → /nix
    └── swap LV (16G)
```

## On reinstall

`disko.nix` will become the single source of truth.

Before running disko:

1. **Update LV sizes** - check current values with `sudo lvdisplay`:
   - `root` size (currently placeholder `1000G`)
   - `swap` size (currently placeholder `16G`)

2. **Confirm device path** - `disko.nix` defaults to `/dev/nvme0n1`; override
   via `--disk nvme0n1=/dev/...` if needed.

3. **Remove UUID overrides** from `default.nix` - once disko manages the disk,
   the LUKS device and ESP should be referenced by the GPT labels disko sets,
   not by UUID.

4. Run disko, then `nixos-install` as usual.
