{ lib, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  # pool creation is not declarative in NixOS. you declare import + mounts
  # create the pool once with stable /dev/disk/by-id paths then NixOS manages it
  #
  # Example dataset policy
  #   tank/data      -> important data
  #   tank/backups   -> replicated data landing zone
  #
  # Define mounts via fileSystems for fixed mountpoints
  # fileSystems."/tank/data" = {
  #   device = "tank/data";
  #   fsType = "zfs";
  # };
}
