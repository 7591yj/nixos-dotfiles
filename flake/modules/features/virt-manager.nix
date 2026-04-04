{ ... }:
{
  repo.featureRegistry.virt-manager = {
    platforms = [ "nixos" ];
    nixosModules = [ "virt-manager" ];
  };
}
