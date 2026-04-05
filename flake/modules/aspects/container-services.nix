{ ... }:
{
  repo.aspects.container-services = {
    platforms = [ "nixos" ];
    nixosModules = [ ../../../modules/nixos/services/container-services ];
  };
}
