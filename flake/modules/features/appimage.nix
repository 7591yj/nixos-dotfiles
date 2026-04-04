{ ... }:
{
  repo.featureRegistry.appimage = {
    platforms = [ "nixos" ];
    nixosModules = [ "appimage" ];
  };
}
