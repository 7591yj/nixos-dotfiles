{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-uuid/8f4e044b-3d7a-4bfb-b8bc-eab9fdb36645";
    preLVM = true;
    allowDiscards = true;
  };
}
