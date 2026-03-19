# juniper-srv-vm

NixOS VM running inside Proxmox on the juniper-srv-vm physical host.

## Physical host layout (Proxmox bare metal)

| Device     | Role                                         |
| ---------- | -------------------------------------------- |
| Small NVMe | Proxmox OS only (EFI + root)                 |
| 1TB NVMe   | `fast` ZFS pool — VM disks, ISOs, templates  |
| 2× 8TB HDD | `tank` ZFS mirror — durable data and backups |

Proxmox manages the physical disks and ZFS pools. This NixOS config has no
visibility into `fast` or `tank` — those are Proxmox storage.

## VM layout (this config)

- Single virtual disk stored on Proxmox `fast` pool
- `rpool`: ZFS, single-disk (Proxmox snapshots provide recovery)
- No swap in the VM (zram preferred)
- EFI boot via systemd-boot

The declarative disk layout is in [`disko.nix`](./disko.nix).

If the VM needs durable storage (e.g. media, backups), attach an additional
virtual disk stored on Proxmox `tank`, or use network storage backed by `tank`.
Do not put anything important on `rpool` only.

## Proxmox VM creation

Before running disko, create the VM in Proxmox:

1. Create VM with QEMU/KVM, UEFI BIOS (OVMF), VirtIO SCSI controller.
2. Add a virtual disk on `fast` pool (e.g. 32–64 GB).
3. Boot from NixOS installer ISO stored on `fast`.

## Install flow

1. Boot the NixOS installer ISO in the Proxmox VM.
2. Identify the virtual disk (typically `/dev/vda`):
   ```
   lsblk
   ```
3. Partition and format with disko:
   ```bash
   sudo nix run github:nix-community/disko -- \
     --mode disko /mnt/etc/nixos/hosts/juniper-srv-vm/disko.nix \
     --disk vda /dev/vda
   ```
4. Install from this flake:
   ```bash
   sudo nixos-install --flake .#juniper-srv-vm
   ```

## ZFS notes

- `rpool` uses native ZFS encryption with `keylocation=prompt`.
- Expect to enter the passphrase at pool creation time and at each boot.
- `networking.hostId` in [`default.nix`](./default.nix) must stay stable for
  ZFS.
- `rpool` is single-disk — no RAID. Recovery is via Proxmox VM snapshots or
  backup to `tank`.

## First access

- SSH password login is disabled.
- Root SSH login is disabled.
- SSH access via the authorized key declared in [`default.nix`](./default.nix).

After first boot:

1. Verify SSH access as `u7591yj`.
2. Set a local password for `u7591yj` if console login is desired.
3. Confirm `rpool` imports cleanly after reboot.
4. Confirm Tailscale comes up before relying on service access through the
   tailnet.
