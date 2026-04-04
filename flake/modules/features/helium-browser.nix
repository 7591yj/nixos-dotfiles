{ ... }:
{
  repo.featureRegistry.helium-browser = {
    platforms = [ "nixos" ];
    nixosModules = [ "helium-browser" ];
  };
}
