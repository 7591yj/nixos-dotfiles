{ ... }:
{
  repo.hosts.juniper-srv-vm = {
    platform = "nixos";
    system = "x86_64-linux";
    channel = "stable";
    user = "u7591yj";
    aspects = [
      "server-role"
      "container-services"
      "disko"
    ];
    stateVersion = "25.11";
    homeStateVersion = "25.11";
    nixosModules = [
      ../../../hosts/juniper-srv-vm/hardware-configuration.nix
      ../../../hosts/juniper-srv-vm/default.nix
    ];
    diskoModule = ../../../hosts/juniper-srv-vm/disko.nix;
  };
}
