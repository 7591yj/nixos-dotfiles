{
  disko.devices = {
    disk.nvme0n1 = {
      type = "disk";
      device = "/dev/nvme0n1"; # overridden at install time via --disk flag
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
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

          lvm = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "vg";
            };
          };
        };
      };
    };

    lvm_vg.vg = {
      type = "lvm_vg";
      lvs = {
        root = {
          size = "1000G"; # placeholder; update from `sudo lvdisplay` before reinstall
          content = {
            type = "btrfs";
            # disko auto-appends subvol=<name>; do NOT include it in mountOptions
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = ["compress=zstd"];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = ["compress=zstd"];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };

        swap = {
          size = "16G"; # placeholder; update from `sudo lvdisplay` before reinstall
          content = {type = "swap";};
        };
      };
    };
  };
}
