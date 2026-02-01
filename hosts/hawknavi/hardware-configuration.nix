# generate with: nixos-generate-config --show-hardware-config
# replace this file's contents with the output

{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")  # change based on actual hardware
  ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # placeholder root filesystem - replace with actual disk layout
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # required for ZFS - generate with: head -c 8 /etc/machine-id
  networking.hostId = "00000000";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
