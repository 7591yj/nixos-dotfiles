{ lib, ... }:

{
  services.tailscaleProxy.tailnetDomain = "follow-bigeye.ts.net";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  imports = [
    ./hardware-configuration.nix
    ../../nixos/modules/roles/server.nix
    ../../nixos/modules/storage/zfs-tank.nix
    ../../nixos/modules/services/container-services
  ];

  networking.hostName = "hawknavi";
  # get actual for baremetal
  networking.hostId = "8425e349";

  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs.devNodes = "/dev";
  boot.zfs.extraPools = [ "tank" ];
  boot.zfs.requestEncryptionCredentials = [ "rpool" "tank" ];

  boot.zfs.forceImportRoot = true;

  fileSystems."/" = {
    device = "rpool/system/root/nixos";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/nix" = {
    device = "rpool/local/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/log" = {
    device = "rpool/local/log";
    fsType = "zfs";
    options = [ "zfsutil" ];
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "rpool/user/home";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/tank/media" = {
    device = "tank/media";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib/jellyfin/config" = {
    device = "rpool/services/jellyfin/config";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib/jellyfin/cache" = {
    device = "rpool/services/jellyfin/cache";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = lib.mkForce {
    # use id for baremetal 
    device = "/dev/vda1";
    fsType = "vfat";
  };

  swapDevices = [
    {
      # use id for baremetal 
      device = "/dev/vda2";
      randomEncryption = true;
    }
  ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";

  users.users.root.hashedPassword = "!"; 
  users.users.u7591yj = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "25.11";
}
