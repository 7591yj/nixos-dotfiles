{ ... }:
{
  repo.hosts.juniper-srv-vm = {
    platform = "nixos";
    system = "x86_64-linux";
    channel = "stable";
    user = "u7591yj";
    roles = [ "server-role" ];
    features = [
      "container-services"
      "disko"
    ];
    stateVersion = "25.11";
    homeStateVersion = "25.11";
    nixosModules = [
      "juniper-hardware"
      "juniper-host"
    ];
    diskoModule = "juniper-disko";
  };
}
