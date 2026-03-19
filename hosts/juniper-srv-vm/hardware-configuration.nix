{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.initrd.availableKernelModules = ["virtio_pci" "virtio_blk" "virtio_scsi" "xhci_pci" "usb_storage" "usbhid"];
  boot.initrd.kernelModules = ["zfs"];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
