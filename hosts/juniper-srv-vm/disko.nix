# Disko disk layout for juniper-srv-vm (NixOS VM in Proxmox)
#
# Single virtual disk (Proxmox QEMU/virtio) → EFI + rpool (ZFS)
#
# Proxmox manages the physical disks and ZFS pools (fast, tank).
# This VM only sees its own virtual disk
#
# At install time override the device path:
#   --disk vda /dev/vda
#   (or /dev/sda if using IDE/SATA emulation)
{
  disko.devices = {
    disk = {
      # ── Virtual disk: EFI + rpool ─────────────────────────────────────────
      vda = {
        type = "disk";
        device = "/dev/vda"; # overridden at install time via --disk flag
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      # ── rpool (single virtual disk) ────────────────────────────────────────
      rpool = {
        type = "zpool";
        mode = ""; # single disk, no redundancy (Proxmox snapshots provide recovery)
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
          dnodesize = "auto";
          normalization = "formD";
          relatime = "on";
          canmount = "off";
          mountpoint = "none";
        };

        datasets = {
          # ── intermediate containers ────────────────────────────────────────
          "system" = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
            };
          };
          "system/root" = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
            };
          };
          "local" = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
            };
          };
          "user" = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
            };
          };

          # ── actual mounts ──────────────────────────────────────────────────
          "system/root/nixos" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
          "local/log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options.mountpoint = "legacy";
          };
          "user/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
