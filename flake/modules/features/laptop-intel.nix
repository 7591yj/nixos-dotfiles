{ ... }:
{
  repo.featureRegistry.laptop-intel = {
    platforms = [ "nixos" ];
    nixosModules = [ "laptop-intel" ];
  };
}
