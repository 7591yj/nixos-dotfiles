{ ... }:

{
  # boot.initrd.luks.devices.<name> = { device = "..."; ... };

  imports = [
    ./hardware-configuration.nix
    ../../nixos/modules/roles/server.nix
    ../../nixos/modules/storage/zfs-tank.nix
  ];

  networking.hostName = "hawknavi";

  system.stateVersion = "25.11";
}
