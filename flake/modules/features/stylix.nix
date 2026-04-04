{ ... }:
{
  repo.featureRegistry.stylix = {
    platforms = [ "nixos" ];
    nixosModules = [ "stylix-local" ];
  };
}
