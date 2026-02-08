{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  imports = [
    ./hardware-configuration.nix
    ../../nixos/modules/roles/server.nix
    ../../nixos/modules/storage/zfs-tank.nix
  ];

  networking.hostName = "hawknavi";
  networking.hostId = "AAAAAAAA";

  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.zfs.extraPools = [ "tank" ];
  boot.zfs.requestEncryptionCredentials = [ "rpool" "tank" ];

  systemd.services.zfs-mount.enable = false;

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

  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/ESP-UUID";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/SWAP-UUID";
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
