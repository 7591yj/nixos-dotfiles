{ ... }:
{
  repo.featureRegistry.container-services = {
    platforms = [ "nixos" ];
    nixosModules = [ "container-services" ];
  };
}
