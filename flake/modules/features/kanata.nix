{ ... }:
{
  repo.featureRegistry.kanata = {
    platforms = [ "nixos" ];
    nixosModules = [ "kanata" ];
  };
}
